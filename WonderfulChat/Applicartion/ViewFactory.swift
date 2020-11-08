//
//  ViewFactory.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 02.11.2020.
//

import Foundation
import SwiftUI

protocol IViewFactory {
    func authorizationView() -> AnyView
    func activeUsersListView() -> AnyView
    func chatView(user: User) -> AnyView
}

class ViewFactory: IViewFactory {
    
    // depencencies
    private let chatService = ChatService()
    private let authorizationService = AuthorizationService()
    
    func authorizationView() -> AnyView {
        let viewModel = AuthorizationViewModel(
            authorizationService: authorizationService)
        let view = AuthorizationView(viewModel: viewModel)
        return AnyView(view)
    }
    
    func activeUsersListView() -> AnyView {
        let viewModel = ActiveUsersListViewModel(
            authorizationService: authorizationService,
            chatService: chatService,
            viewFactory: self)
        let view = ActiveUsersListView(viewModel: viewModel)
        return AnyView(view)
    }
    
    func chatView(user: User) -> AnyView {
        let viewModel = ChatViewModel(user: user)
        let view = ChatView(viewModel: viewModel)
        return AnyView(view)
    }
}
