//
//  UserDefaultsService.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 04.11.2020.
//

import Foundation

enum UserDefaultsKey: String {
    case userName
    case userId
}

@propertyWrapper
struct UserDefaultsStorage<T> {
    private let key: UserDefaultsKey

    init(_ key: UserDefaultsKey) {
        self.key = key
    }

    var wrappedValue: T? {
        get {
            UserDefaults.standard.object(forKey: key.rawValue) as? T
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }
}
