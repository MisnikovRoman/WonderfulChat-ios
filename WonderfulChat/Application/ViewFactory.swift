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
    func errorView(description: String, retryAction: (() -> Void)?) -> AnyView
}

class ViewFactory: IViewFactory {
    
    // depencencies
    private let authorizationService = AuthorizationService()
    private let settingContainer = SettingContainer()
    private lazy var chatService = ChatService(settingsContainer: settingContainer)
    
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
        let view = ActiveUsersListScreen(viewModel: viewModel)
        return AnyView(view)
    }
    
    func chatView(user: User) -> AnyView {
        let viewModel = ChatViewModel(
            user: user,
            authorizationService: authorizationService,
            chatService: chatService,
            viewFactory: self)
        let view = ChatView(viewModel: viewModel)
        return AnyView(view)
    }
    
    func debugView() -> AnyView {
        let viewModel = DebugViewModel(
            settingsContainer: settingContainer,
            chatService: chatService)
        let view = DebugView(viewModel: viewModel)
        return AnyView(view)
    }
    
    func errorView(description: String, retryAction: (() -> Void)? = nil) -> AnyView {
        let viewModel = ErrorViewModel()
        let view = ErrorView(viewModel: viewModel)
        return AnyView(view)
    }
}
