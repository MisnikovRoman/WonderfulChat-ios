//
//  Network.swift
//  WonderfulChat
//
//  Created by Roman Misnikov on 25.10.2020.
//

import Foundation

enum NetworkError: Error {
    case noData
}

class Network {

    private let decoder = JSONDecoder()
    private var webSocketTask: URLSessionWebSocketTask?
    
    var onReceiveMessage: ((String) -> ())?

    func get<T: Decodable>(from url: URL, _ type: T.Type, completion: @escaping (Result<T, Error>)->()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            guard let data = data else { return completion(.failure(NetworkError.noData)) }
            do {
                let model = try self.decoder.decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func connectWebSocket(request: URLRequest) {
        if let openWebSocketTask = webSocketTask {
            openWebSocketTask.cancel(with: .goingAway, reason: nil)
        }
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        setHandlerToInputMessage()
        webSocketTask?.resume()
    }
    
    func disconnectWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }

    func sendMessage(_ text: String) {
        guard let task = webSocketTask else { return print("⚠️ Ошибка: не создано соединение с websocket") }
        let message = URLSessionWebSocketTask.Message.string(text)
        task.send(message) { error in
            guard let _ = error else { return }
            assertionFailure("⚠️ Ошибка отправки сообщения: \"\(text)\"")
        }
    }
}

private extension Network {
    func setHandlerToInputMessage() {
        webSocketTask?.receive{ [weak self] result in
            switch result {
            case .success(let message):
                if case let .string(text) = message {
                    self?.onReceiveMessage?(text)
                }
            case .failure(let error):
                assertionFailure("⚠️ Ошибка получения сообщения: \(error.localizedDescription)")
            }
            self?.setHandlerToInputMessage()
        }
    }
}
