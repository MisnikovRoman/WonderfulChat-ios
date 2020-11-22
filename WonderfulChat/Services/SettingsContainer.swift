//
//  SettingsContainer.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 08.11.2020.
//

import Foundation

class SettingContainer {
    var availableEndpoints = API.Host.allCases
    var selectedEndpoint = API.Host.local
}
