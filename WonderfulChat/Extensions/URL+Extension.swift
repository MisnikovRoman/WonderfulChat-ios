//
//  URL+Extension.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 08.11.2020.
//

import Foundation

extension URL {
    init?(scheme: API.Scheme, host: API.Host, path: API.Path) {
        self.init(string: scheme.rawValue + host.rawValue + path.rawValue)
    }
}
