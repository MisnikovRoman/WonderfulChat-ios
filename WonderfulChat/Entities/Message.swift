//
//  Message.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 07.11.2020.
//

import Foundation

struct Message: Codable {
    let id: String
    let senderId: String
    let receiverId: String
    let text: String
}
