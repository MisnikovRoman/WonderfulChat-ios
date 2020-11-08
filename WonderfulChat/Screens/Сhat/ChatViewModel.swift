//
//  ChatViewModel.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 07.11.2020.
//

import Foundation

class ChatViewModel: ObservableObject {
    let user: User
    
    @Published
    var messages: [Message] = []
    @Published
    var newMessage: String = ""
    
    init(user: User) {
        self.user = user
        addMockMessages()
    }
    
    func sendMessage() {
        guard newMessage != "" else { return }
        messages.append(Message(text: newMessage, sender: .myself))
        newMessage = ""
    }
    
    private func addMockMessages() {
        messages = [
            Message(text: "Hello", sender: .user(id: user.id)),
            Message(text: "How are you?", sender: .user(id: user.id)),
            Message(text: "Hi ✌️", sender: .myself),
            Message(text: "I'm fine", sender: .myself)
        ]
    }
}
