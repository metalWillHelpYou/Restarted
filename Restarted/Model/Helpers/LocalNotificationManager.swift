//
//  NotificationManager.swift
//  Restarted
//
//  Created by metalWillHelpYou on 11.10.2024.
//

import Foundation
import UserNotifications
import SwiftUI

@MainActor
class LocalNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var isGranted = true
    @Published var pendingRequests: [UNNotificationRequest] = []
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequests()
        return [.sound, .banner]
    }
    
    func requestAuthorization() async throws {
        try await notificationCenter.requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentSettings()
    }
    
    func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    
    // Планирование уведомления для окончания таймера
    func scheduleTimerEndedNotification(duration: TimeInterval) async {
        let content = UNMutableNotificationContent()
        content.title = "Время истекло!"
        content.body = "Ваш таймер завершен."
        content.sound = .default
        
        // Используем TimeInterval для триггера уведомления
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duration, repeats: false)
        let request = UNNotificationRequest(identifier: "TimerEnded", content: content, trigger: trigger)
        
        try? await notificationCenter.add(request)
        await getPendingRequests()
    }
    
    // Получение списка запланированных уведомлений
    func getPendingRequests() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
    }
    
    func removeRequest(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        if let index = pendingRequests.firstIndex(where: { $0.identifier == identifier }) {
            pendingRequests.remove(at: index)
        }
    }
    
    func clearRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
        pendingRequests.removeAll()
    }
    
    // Обработка нажатия на уведомление
    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "TimerEnded" {
            DispatchQueue.main.async {
                // Отправляем уведомление о необходимости открыть экран настройки таймера
                NotificationCenter.default.post(name: NSNotification.Name("NavigateToSetUpTimer"), object: nil)
            }
        }
        completionHandler()
    }
}
