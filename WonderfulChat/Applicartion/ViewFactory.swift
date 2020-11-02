//
//  ViewFactory.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 02.11.2020.
//

import Foundation

class ViewFactory: ObservableObject {
    
    // depencencies
    private let chatService = ChatService()
    private let user = User()
    
    func introduceView() -> IntroduceView {
        IntroduceView(user: user)
    }
    
    func activeUsersListView() -> ActiveUsersListView {
        ActiveUsersListView(
            chatService: chatService,
            user: user)
    }
    
    func chatView() -> ChatView {
        ChatView()
    }
}
