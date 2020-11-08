//
//  AuthorizationViewModel.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 05.11.2020.
//

import Foundation

class AuthorizationViewModel: ObservableObject {
    
    private let authorizationService: IAuthorizationService
    
    @Published
    var enteredUserName: String = ""
    
    var isLoginButtonEnabled: Bool {
        enteredUserName.count > 3
    }
    
    init(authorizationService: IAuthorizationService) {
        self.authorizationService = authorizationService
    }
    
    func login() {
        let user = User(id: UUID().uuidString, name: enteredUserName)
        authorizationService.logIn(user: user)
    }
}
