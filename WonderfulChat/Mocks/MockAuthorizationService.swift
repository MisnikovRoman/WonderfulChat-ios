//
//  MockAuthorizationService.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 05.11.2020.
//

import Combine

class MockAuthorizationService: IAuthorizationService {    
    var authorizationPublisher: AnyPublisher<User?, Never> = Just(User(id: "asd", name: "Ivan")).eraseToAnyPublisher()
    
    var isAuthorized: Bool = false
    
    func logIn(user: User) {
        isAuthorized = true
    }

    func logOut() {
        isAuthorized = false
    }
}
