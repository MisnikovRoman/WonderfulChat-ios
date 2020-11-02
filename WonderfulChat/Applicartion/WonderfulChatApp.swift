//
//  WonderfulChatApp.swift
//  WonderfulChat
//
//  Created by Roman Misnikov on 25.10.2020.
//

import SwiftUI

@main
struct WonderfulChatApp: App {
    
    private let factory = ViewFactory()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                factory.introduceView()
            }.environmentObject(factory)
        }
    }
}
