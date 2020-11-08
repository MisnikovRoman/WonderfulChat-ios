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
    func connect(userId: String, userName: String) {}
    func disconnect() {}
}
