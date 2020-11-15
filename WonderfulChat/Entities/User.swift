//
//  User.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 01.11.2020.
//

import SwiftUI

struct User: Identifiable, Codable {
    let id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(name: String) {
        self.init(id: UUID().uuidString, name: name)
    }
}
