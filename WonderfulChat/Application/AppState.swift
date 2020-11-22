//
//  AppState.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 04.11.2020.
//

import Combine

class AppState: ObservableObject {
    
    // Private
    @UserDefaultsStorage(.userName)
    private var userName: String?
    @UserDefaultsStorage(.userId)
    private var userId: String?

    private var cancelable: AnyCancellable?
    
    // Public
    @Published
    var user: User?
    @Published
    var isAuthorized: Bool = false
    
    let viewFactory = ViewFactory()
    
    init() {
        if let id = userId, let name = userName {
            user = User(id: id, name: name)
        }
        cancelable = $user.sink(receiveValue: onUserUpdate)
    }
}

private extension AppState {
    func onUserUpdate(user: User?) {
        userName = user?.name
        userId = user?.id
        isAuthorized = user?.name != nil
    }
}
