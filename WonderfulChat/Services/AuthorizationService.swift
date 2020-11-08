//
//  AuthorizationService.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 05.11.2020.
//

import Combine

protocol IAuthorizationService {
    /// Источник событий авторизации пользователя
    var authorizationPublisher: AnyPublisher<User?, Never> { get }
    var isAuthorized: Bool { get }
    var user: User? { get }
    func logIn(user: User)
    func logOut()
}

class AuthorizationService: IAuthorizationService {

    @UserDefaultsStorage(.userName)
    private var userName: String?
    @UserDefaultsStorage(.userId)
    private var userId: String?
    
    private let authorizationPassthroughSubject = CurrentValueSubject<User?, Never>(nil)
    lazy var authorizationPublisher = authorizationPassthroughSubject.eraseToAnyPublisher()
    
    init() {
        if let name = userName, let id = userId  {
            let user = User(id: id, name: name)
            authorizationPassthroughSubject.send(user)
        } else {
            authorizationPassthroughSubject.send(nil)
        }
    }
    
    var user: User? {
        guard let id = userId, let name = userName else { return nil }
        return User(id: id, name: name)
    }
    
    var isAuthorized: Bool {
        user != nil
    }
    
    func logIn(user: User) {
        userName = user.name
        userId = user.id
        authorizationPassthroughSubject.send(user)
    }
    
    func logOut() {
        userName = nil
        userId = nil
        authorizationPassthroughSubject.send(nil)
    }
}
