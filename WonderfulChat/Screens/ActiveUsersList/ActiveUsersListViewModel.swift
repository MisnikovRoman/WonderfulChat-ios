//
//  ActiveUsersListViewModel.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 05.11.2020.
//

import Foundation
import SwiftUI
import Combine

class ActiveUsersListViewModel: ObservableObject {
    enum Route {
        case authorization
        case chat(User)
    }
    
    enum State {
        case loading
        case userList
        case error
    }
    
    // dependencies
    private let authorizationService: IAuthorizationService
    private var chatService: IChatService
    private let viewFactory: IViewFactory
    
    // private varibles
    private var cancellables = Set<AnyCancellable>()
    private var user: User? { authorizationService.user }
    
    // public variables
    @Published var activeUsers = [User]()
    @Published var isNotAuthorized = true
    @Published var userName = ""
    @Published var viewState = State.loading
    
    init(authorizationService: IAuthorizationService, chatService: IChatService, viewFactory: IViewFactory) {
        self.authorizationService = authorizationService
        self.chatService = chatService
        self.viewFactory = viewFactory
        setup()
    }
     
    func logout() {
        authorizationService.logOut()
        chatService.disconnect()
    }
    
    func go(to route: Route) -> AnyView {
        switch route {
        case .authorization:
            return viewFactory.authorizationView()
        case .chat(let user):
            return viewFactory.chatView(user: user)
        }
    }
    
    func didAppear() {
        connect()
    }
    
    func didDisappear() {
        // nothing
    }
    
    func retryConnection() {
        connect()
    }
    
    func testSendMessage() {
        chatService.send("👋🏻 Hello websocket")
    }
}

private extension ActiveUsersListViewModel {
    func setup() {
        
        // subscribe on authorization events
        authorizationService.authorizationPublisher
            .sink { [weak self] user in
                self?.userName = user?.name ?? ""
                self?.isNotAuthorized = user == nil
                
                if let authentificatedUser = user {
                    self?.chatService.connect(
                        userId: authentificatedUser.id,
                        userName: authentificatedUser.name)
                }
            }.store(in: &cancellables)
        
        // subscribe on active users events
        chatService.activeUsersPublisher
            .assign(to: &$activeUsers)
        
        // subcribe on connection events
        chatService.statePublisher
            .map { chatServiceState in
                switch chatServiceState {
                case .notConnected: return .error
                case .connecting:   return .loading
                case .connected:    return .userList
                }
            }
            .assign(to: &$viewState)
        
        chatService.errorPublisher
            .map { _ in State.error }
            .assign(to: &$viewState)
    }
    
    func connect() {
        guard let authentificatedUser = user else { return }
        chatService.connect(
            userId: authentificatedUser.id,
            userName: authentificatedUser.name)
    }
}
