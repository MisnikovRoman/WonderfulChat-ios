//
//  LocalNotifications.swift
//  WonderfulChat
//
//  Created by Роман Мисников on 02.11.2020.
//

import UserNotifications

class LocalNotifications: NSObject {
    private override init() {}
    static let shared = LocalNotifications()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func present(title: String, subtitle: String) {
        notificationCenter.delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle
        
        // триггер, которому сработает уведомление (время, календарь, геопозиция)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        // запрос в систему на показ уведомления
        let notificationRequest = UNNotificationRequest(identifier: "com.yota.notification.custom", content: content, trigger: trigger)
        
        // проверка разрешения на показ уведомлений
        notificationCenter.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                return assertionFailure("❌ Нет разрешения на показ уведомлений")
            }
            
            // добавление уведомления в центр уведомлений
            self.notificationCenter.add(notificationRequest) { (error) in
                if let error = error {
                    return assertionFailure("❌ Ошибка показа уведомлений: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension LocalNotifications: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([ .alert, .sound ])
    }
}
