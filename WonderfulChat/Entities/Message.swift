//
//  Message.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 07.11.2020.
//

import Foundation

enum MessageSender: Equatable, Hashable {
    case myself, user(id: String)
}

struct Message: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let sender: MessageSender
}
