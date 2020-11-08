//
//  WonderfulChatApp.swift
//  WonderfulChat
//
//  Created by Roman Misnikov on 25.10.2020.
//

import SwiftUI
import UserNotifications

@main
struct WonderfulChatApp: App {
    
    private let viewFactory = ViewFactory()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                viewFactory.activeUsersListView()
            }
            .onAppear(perform: setupLocalNotifications)
        }
    }
}

extension WonderfulChatApp {
    func setupLocalNotifications() {
        let options: UNAuthorizationOptions = [.badge, .alert]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
                print("⚠️ User has declined notifications")
            }
        }
    }
}
