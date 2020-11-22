//
//  MockChatService.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 02.11.2020.
//

import Combine

class MockChatService: IChatService {
    var statePublisher: AnyPublisher<ChatService.State, Never> {
        Just(.connected)
            .eraseToAnyPublisher()
    }
    
    var activeUsersPublisher: AnyPublisher<[User], Never> {
        Just([User(id: "0", name: "TestUser0"),
              User(id: "1", name: "TestUser1")])
            .eraseToAnyPublisher()
    }
    
    var messagePublisher: AnyPublisher<Message, Never> {
        Just(Message(id: "0", senderId: "0", receiverId: "1", text: "Hello world!"))
            .eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<ChatServiceError, Never> {
        Empty()
            .eraseToAnyPublisher()
    }
    

    
    func connect(userId: String, userName: String) {}
    func disconnect() {}
    func send(_ text: String) {}
}
