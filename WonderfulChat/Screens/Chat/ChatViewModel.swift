//
//  ChatViewModel.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 07.11.2020.
//

import Foundation
import Combine
import SwiftUI

struct MessageViewModel: Identifiable {
    let id = UUID()
    let text: String
    let isMyMessage: Bool
}

class ChatViewModel: ObservableObject {
    
    enum Route {
        case error(Error)
    }
    
    private let authorizationService: IAuthorizationService
    private let chatService: IChatService
    private let viewFactory: IViewFactory
    private var cancellables = Set<AnyCancellable>()
    
    /// Собеседник
    let interlocutor: User
    
    @Published var messages = [MessageViewModel]()
    @Published var newMessage = ""
    /// Наличие необработанной ошибки (необходимость показать экран ошибки)
    @Published var haveUnhandledError: Bool = false
    
    init(user: User, authorizationService: IAuthorizationService, chatService: IChatService, viewFactory: IViewFactory) {
        self.interlocutor = user
        self.authorizationService = authorizationService
        self.chatService = chatService
        self.viewFactory = viewFactory
        setup()
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
    
    func route(to route: Route) -> AnyView {
        switch route {
        case .error(let error):
            return viewFactory.errorView(description: error.localizedDescription) {
                print("🧯 Retrying")
            }
        }
    }
}

private extension ChatViewModel {
    
    func setup() {
        chatService.messagePublisher
            .filter { [weak self] message in
                message.senderId == self?.interlocutor.id
            }.sink { [weak self] newMessage in
                self?.messages.append(MessageViewModel(text: newMessage.text, isMyMessage: false))
            }.store(in: &cancellables)
    }
    
    func isMyMessage(_ message: Message) -> Bool {
        message.senderId == authorizationService.user?.id
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
