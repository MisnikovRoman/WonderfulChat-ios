//
//  MockChatService.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 02.11.2020.
//

import Combine

class MockChatService: IChatService {
    var activeUsersPublisher: AnyPublisher<[String], Never> {
        Just(["Ivan", "Stepan"]).eraseToAnyPublisher()
    }
    
    func connect(userId: String, userName: String) {}
    func disconnect() {}
}
