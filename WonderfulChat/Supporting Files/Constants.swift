//
//  Constants.swift
//  WonderfulChat
//
//  Created by Roman Misnikov on 25.10.2020.
//

enum API {
    enum Scheme: String, CaseIterable {
        case ws = "ws://"
        case https = "https://"
    }
    
    enum Host: String, CaseIterable {
        case local = "127.0.0.1:8080"
        case heroku = "wonderfulchat.herokuapp.com"
    }
    
    enum Path: String, CaseIterable {
        case chat = "/chat"
    }
}
