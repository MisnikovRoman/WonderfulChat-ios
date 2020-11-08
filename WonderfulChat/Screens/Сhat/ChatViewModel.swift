//
//  ChatViewModel.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 07.11.2020.
//

import Foundation

struct MessageViewModel: Identifiable {
    let id = UUID()
    let text: String
    let isMyMessage: Bool
}

class ChatViewModel: ObservableObject {
    private let authorizationService: IAuthorizationService
    private let chatService: IChatService
    let interlocutor: User
    
    @Published
    var messages: [MessageViewModel] = []
    @Published
    var newMessage: String = ""
    
    init(user: User, authorizationService: IAuthorizationService, chatService: IChatService) {
        self.interlocutor = user
        self.authorizationService = authorizationService
        self.chatService = chatService
        addMockMessages()
    }
    
    func sendMessage() {
        guard newMessage != "" else { return }
        defer { newMessage = "" }
        messages.append(MessageViewModel(text: newMessage, isMyMessage: true))
        let message = Message(
            id: UUID().uuidString,
            senderId: authorizationService.user?.id ?? "",
            receiverId: interlocutor.id,
            text: newMessage)
        chatService.send(message.toJsonString())
    }
}

private extension ChatViewModel {
    
    func isMyMessage(_ message: Message) -> Bool {
        message.senderId == authorizationService.user?.id
    }

    func addMockMessages() {
        messages = [
            MessageViewModel(text: "Hello", isMyMessage: false),
            MessageViewModel(text: "How are you?", isMyMessage: false),
            MessageViewModel(text: "Hi ✌️", isMyMessage: true),
            MessageViewModel(text: "I'm fine", isMyMessage: true)
        ]
    }
}

private extension Encodable {
    func toJsonString() -> String {
        guard let data = try? JSONEncoder().encode(self),
              let json = String(data: data, encoding: .utf8)
        else {
            assertionFailure("Невозможно декодировать данные")
            return ""
        }
        return json
    }
}
