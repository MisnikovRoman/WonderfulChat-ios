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

    func connectWebSocket(url: URL) {
        guard let url = URL(string: Api.websocketUrl) else { return }
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
    }

    func sendMessage(_ text: String) {
        guard let task = webSocketTask else { return print("⚠️ Ошибка: не создано соединение с websocket") }
        let message = URLSessionWebSocketTask.Message.string(text)
        task.send(message) { error in
            guard let _ = error else { return }
            assertionFailure("⚠️ Ошибка отправки сообщения: \"\(text)\"")
        }
    }

    func onReceiveMessage(perform: @escaping (String)->()) {
        guard let task = webSocketTask else { return print("⚠️ Ошибка: не создано соединение с websocket") }
        task.receive { result in
            switch result {
            case .success(let message):
                if case let .string(text) = message {
                    perform(text)
                }
            case .failure(let error):
                assertionFailure("⚠️ Ошибка получения сообщения: \(error.localizedDescription)")
            }
        }
    }

    func ping() {
        webSocketTask?.sendPing { error in
            guard let _ = error else { return }
        }
    }
}
