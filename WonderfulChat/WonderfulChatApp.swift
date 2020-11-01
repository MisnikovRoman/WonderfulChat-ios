//
//  WonderfulChatApp.swift
//  WonderfulChat
//
//  Created by Roman Misnikov on 25.10.2020.
//

import SwiftUI

@main
struct WonderfulChatApp: App {
    
    private let user = User()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                IntroduceView()
            }.environmentObject(user)
        }
    }
}
