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
    
    // dependencies
    private let authorizationService: IAuthorizationService
    private var chatService: IChatService
    private let viewFactory: IViewFactory
    
    // private varibles
    private var trash: [AnyCancellable] = []
    private var user: User? { authorizationService.user }
    
    // public variables
    @Published
    var activeUsers: [String] = []
    @Published
    var isNotAuthorized: Bool = true
    @Published
    var userName: String = ""
    
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
        guard let authentificatedUser = user else { return }
        chatService.connect(
            userId: authentificatedUser.id,
            userName: authentificatedUser.name)
    }
    
    func didDisappear() {
        chatService.disconnect()
    }
}

extension ActiveUsersListViewModel: ChatServiceDelegate {
    func didConnect() {
        //
    }
    
    func didDisconnect(with closeCode: Int) {
        //
    }
    
    func didReceive(message: String, from: String) {
        //
    }
    
    func didReceive(activeUsers: [String]) {
        DispatchQueue.main.async {
            self.activeUsers = activeUsers            
        }
    }
    
    func didReceive(error: Error) {
        //
    }
}

private extension ActiveUsersListViewModel {
    func setup() {
        chatService.delegate = self
        
        let authorizationUserCancellable = authorizationService.authorizationPublisher.sink { [weak self] user in
            self?.userName = user?.name ?? ""
            self?.isNotAuthorized = user == nil
            
            if let authentificatedUser = user {
                self?.chatService.connect(
                    userId: authentificatedUser.id,
                    userName: authentificatedUser.name)
            }
        }
        trash.append(authorizationUserCancellable)
    }
}
