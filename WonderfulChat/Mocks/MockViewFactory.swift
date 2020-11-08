//
//  MockViewFactory.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 05.11.2020.
//

import SwiftUI

class MockViewFactory: IViewFactory {
    func authorizationView() -> AnyView {
        AnyView(Text("Authorization view"))
    }
    
    func activeUsersListView() -> AnyView {
        AnyView(Text("Active users list view"))
    }
    
    func chatView(user: User) -> AnyView {
        AnyView(Text("Chat view with user: \(user.name)"))
    }
}
