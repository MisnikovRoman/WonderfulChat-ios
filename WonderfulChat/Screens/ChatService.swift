//
//  ChatService.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 01.11.2020.
//

import Foundation
import Combine

class ChatService {
    private let network = Network()

    let activeUsersPublisher = PassthroughSubject<[String], Never>()
    
    func connect(userId: String, userName: String) {
        guard let url = URL(string: Api.heroku + Route.chat) else { return }
        
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
        activeUsersPublisher.send(
            message
                .replacingOccurrences(of: " ", with: "")
                .split(separator: ",")
                .map { String($0) }
        )
    }
}
