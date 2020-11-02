//
//  ChatService.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 01.11.2020.
//

import Foundation
import Combine

protocol IChatService {
    var activeUsersPublisher: AnyPublisher<[String], Never> { get }
    func connect(userId: String, userName: String)
    func disconnect()
}

class ChatService {
    private let network = Network()
    private let activeUsersPassthroughSubject = PassthroughSubject<[String], Never>()
}

extension ChatService: IChatService {
    var activeUsersPublisher: AnyPublisher<[String], Never> {
        activeUsersPassthroughSubject.eraseToAnyPublisher()
    }
    
    func connect(userId: String, userName: String) {
        guard let url = URL(scheme: .ws, host: .heroku, path: .chat) else { return }
        
        var request = URLRequest(url: url)
        request.addValue(userId, forHTTPHeaderField: "id")
        request.addValue(userName, forHTTPHeaderField: "name")
    
        network.connectWebSocket(request: request)
        network.onReceiveMessage = handleIncomingMessage
    }
    
    func disconnect() {
        network.disconnectWebSocket()
    }
}

private extension ChatService {
    func handleIncomingMessage(message: String) {
        activeUsersPassthroughSubject.send(
            message
                .replacingOccurrences(of: " ", with: "")
                .split(separator: ",")
                .map { String($0) }
        )
    }
}
