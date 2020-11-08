//
//  ChatService.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 01.11.2020.
//

import Foundation
import Combine

protocol IChatService {
    var delegate: ChatServiceDelegate? { get set }
    var isConnected: Bool { get }
    func connect(userId: String, userName: String)
    func disconnect()
}

protocol ChatServiceDelegate: AnyObject {
    func didReceive(message: String, from: String)
    func didReceive(activeUsers: [String])
    func didReceive(error: Error)
    func didConnect()
    func didDisconnect(with closeCode: Int)
}

class ChatService: NSObject {
    weak var delegate: ChatServiceDelegate?
    private var webSocketTask: URLSessionWebSocketTask?
    private var pingTimer: Timer?
    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    // Обновляется после получения Pong
    private var isPingSuccess: Bool = false
}

// MARK: - IChatService
extension ChatService: IChatService {
    
    var isConnected: Bool {
        return webSocketTask != nil && isPingSuccess
    }
    
    func connect(userId: String, userName: String) {
        guard !isConnected,
              let request = createRequest(userId: userId, userName: userName) else { return }
        
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.resume()
        
        setInputMessageHandler()
    }
    
    func disconnect() {
        stopPingTimer()
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }
    
    func send(message: String) {
        webSocketTask?.send(.string(message)) { [weak self] error in
            guard let error = error else { return }
            self?.delegate?.didReceive(error: error)
            LocalNotifications.shared.present(
                title: "⚠️ Не удалось отправить сообщение",
                subtitle: "\(error.localizedDescription)")
        }
    }
}

// MARK: - URLSessionWebSocketDelegate
extension ChatService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        delegate?.didConnect()
        runPingTimer()
        
        LocalNotifications.shared.present(
            title: "🕸 Соодинение установлено",
            subtitle: "\(webSocketTask.currentRequest?.url?.absoluteString ?? "") подключен")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        delegate?.didDisconnect(with: closeCode.rawValue)
        stopPingTimer()
        
        LocalNotifications.shared.present(
            title: "📴 Соодинение отключено",
            subtitle: "Сервер отключился с ошибкой \(closeCode.rawValue)")
    }
}

// MARK: - Private
private extension ChatService {
    
    func createRequest(userId: String, userName: String) -> URLRequest? {
        guard let url = URL(scheme: .ws, host: .heroku, path: .chat) else { return nil }
        
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
            case .failure(let error):
                self?.delegate?.didReceive(error: error)
            }
            self?.setInputMessageHandler()
        }
    }
    
    func handleIncomingMessage(message: URLSessionWebSocketTask.Message) {
        guard case let .string(text) = message else { return }
        LocalNotifications.shared.present(title: "💬 Новое сообщение", subtitle: text)
        let activeUsers = text
            .replacingOccurrences(of: " ", with: "")
            .split(separator: ",")
            .map { String($0) }
        delegate?.didReceive(activeUsers: activeUsers)
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
            if let error = error {
                self?.isPingSuccess = false
                self?.delegate?.didReceive(error: error)
                self?.disconnect()
                
                LocalNotifications.shared.present(
                    title: "⚠️ Ошибка пинга",
                    subtitle: "\(error.localizedDescription)")
            } else {
                self?.isPingSuccess = true
            }
        }
    }
}
