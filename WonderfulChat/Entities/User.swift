//
//  User.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 01.11.2020.
//

import SwiftUI

class User: ObservableObject {
    let id = UUID()
    @Published var name: String = ""
}
