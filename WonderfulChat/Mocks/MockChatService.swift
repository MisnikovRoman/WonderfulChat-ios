//
//  MockChatService.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 02.11.2020.
//

import Combine

class MockChatService: IChatService {
    weak var delegate: ChatServiceDelegate?
    let isConnected: Bool = true
    
    var messagesPublisher: AnyPublisher<Message, Never> = Just(
        Message(id: "", senderId: "", receiverId: "", text: "123")
    ).eraseToAnyPublisher()
    
    func connect(userId: String, userName: String) {}
    func disconnect() {}
    func send(_ text: String) {}
}
