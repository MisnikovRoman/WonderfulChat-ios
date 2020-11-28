//
//  ChatService.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 01.11.2020.
//

import Foundation
import Combine

protocol IChatService {
    var statePublisher: AnyPublisher<ChatService.State, Never> { get }
    var activeUsersPublisher: AnyPublisher<[User], Never> { get }
    var messagePublisher:     AnyPublisher<Message, Never> { get }
    var errorPublisher:       AnyPublisher<ChatServiceError, Never> { get }

    /// Подключение к вебсокету
    /// - Parameters:
    ///   - userId: id нового пользователя
    ///   - userName: имя нового пользователя
    func connect(userId: String, userName: String)
    /// Отключение от вебсокета
    func disconnect()
    /// Отправка сообщения на сервер
    func send(_ text: String)
}

enum ChatServiceError {
    case send(Error)
    case receive(Error)
    case connection(Error)
    case webSocketIsNotExists
}



class ChatService: NSObject {
    
    enum State {
        case notConnected, connecting, connected
    }
    
    private let settingsContainer: SettingContainer
    private var webSocketTask: URLSessionWebSocketTask?
    private var pingTimer: Timer?
    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    /// Обновляется после получения Pong
    private var isPingSuccess: Bool = false
    
    // Publishers
    @Published private var state: State = .notConnected
    @Published private var activeUsers: [User] = []
    @Published private var lastMessage: Message?
    @Published private var lastError: ChatServiceError?
    
    init(settingsContainer: SettingContainer) {
        self.settingsContainer = settingsContainer
        super.init()
    }
}

// MARK: - IChatService
extension ChatService: IChatService {
    
    var statePublisher: AnyPublisher<State, Never> { $state.eraseToAnyPublisher() }
    
    var messagePublisher: AnyPublisher<Message, Never> {
        $lastMessage
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    var activeUsersPublisher: AnyPublisher<[User], Never> { $activeUsers.eraseToAnyPublisher() }
    
    var errorPublisher: AnyPublisher<ChatServiceError, Never> {
        $lastError
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func connect(userId: String, userName: String) {
        switch state {
        case .notConnected:
            break
        case .connecting, .connected:
            return
        }

        guard let request = createRequest(userId: userId, userName: userName) else { return }
        session.webSocketTask(with: request).resume()
        print("🌐 New request: /\(request.httpMethod ?? "") \(request.url?.absoluteString ?? "") headers: \(request.allHTTPHeaderFields ?? [:])")
        state = .connecting
    }
    
    func disconnect() {
        webSocketTask = nil
        state = .notConnected
        stopPingTimer()
        
        // closing all active websocket tasks in session
        session.getAllTasks { urlSessionTasks in
            urlSessionTasks
                .compactMap { $0 as? URLSessionWebSocketTask }
                .forEach { $0.cancel(with: .goingAway, reason: nil) }
        }
    }

    func send(_ text: String) {
        guard let task = webSocketTask else { return report(.webSocketIsNotExists) }
        task.send(.string(text)) { [weak self] error in
            guard let systemError = error else { return }
            self?.report(.send(systemError))
        }
    }
}

// MARK: - URLSessionWebSocketDelegate
extension ChatService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.webSocketTask = webSocketTask
        state = .connected
        runPingTimer()
        setInputMessageHandler()
        
        LocalNotifications.shared.present(
            title: "🕸 Соодинение установлено",
            subtitle: "\(webSocketTask.currentRequest?.url?.absoluteString ?? "") подключен")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        guard webSocketTask == self.webSocketTask else { return }
        
        self.webSocketTask = nil
        state = .notConnected
        stopPingTimer()
        
        LocalNotifications.shared.present(
            title: "📴 Соодинение отключено",
            subtitle: "Сервер отключился с ошибкой \(closeCode.rawValue)")
    }
}

// MARK: - Private
private extension ChatService {
    
    func createRequest(userId: String, userName: String) -> URLRequest? {
        guard let url = URL(scheme: .ws, host: settingsContainer.selectedEndpoint, path: .chat) else { return nil }
        
        var request = URLRequest(url: url)
        request.addValue(userId, forHTTPHeaderField: "id")
        request.addValue(userName, forHTTPHeaderField: "name")
        
        return request
    }
    
    func setInputMessageHandler() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                self?.handleIncomingMessage(message: message)
            case .failure(let systemError):
                self?.report(.receive(systemError))
                
                // Обработка ошибки "Socket is not connected" (отключение локального сервера)
                // не срабатывает делегат urlSession(_:webSocketTask:didCloseWith:reason:)
                guard (systemError as NSError).code == 57 else { return }
                self?.webSocketTask = nil
                self?.state = .notConnected
                self?.stopPingTimer()
            }
            self?.setInputMessageHandler()
        }
    }
    
    func handleIncomingMessage(message: URLSessionWebSocketTask.Message) {
        guard case let .string(text) = message else { return }
        
        var debugMessage = (title: "💬 Новое сообщение", subtitle: text)
        defer { LocalNotifications.shared.present(title: debugMessage.title, subtitle: debugMessage.subtitle) }
    
        if let message = try? JSONDecoder().decode(Message.self, from: Data(text.utf8)) {
            lastMessage = message
            debugMessage = (title: message.senderId, subtitle: message.text)
        } else if let users = try? JSONDecoder().decode([User].self, from: Data(text.utf8)) {
            activeUsers = users
        }
    }
    
    func runPingTimer() {
        pingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.ping()
        }
    }
    
    func stopPingTimer() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
    
    func ping() {
        webSocketTask?.sendPing { [weak self] error in
            if let systemError = error {
                self?.isPingSuccess = false
                self?.report(.connection(systemError))
                self?.disconnect()
            } else {
                self?.isPingSuccess = true
            }
        }
    }
    
    func report(_ error: ChatServiceError) {
        lastError = error
        
        switch error {
        case .send(let error):
            LocalNotifications.shared.present(title: "⚠️ Не удалось отправить сообщение", subtitle: error.localizedDescription)
        case .receive(let error):
            LocalNotifications.shared.present(title: "⚠️ Не удалось получить сообщение", subtitle: error.localizedDescription)
        case .connection(let error):
            LocalNotifications.shared.present(title: "⚠️ Неудачный пинг сервера", subtitle: error.localizedDescription)
        case .webSocketIsNotExists:
            LocalNotifications.shared.present(title: "⚠️ Неизвестная ошибка", subtitle: "WebSocketTask отсутствуетs")
        }
    }
}
