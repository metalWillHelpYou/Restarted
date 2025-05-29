//
//  LocalNotificationManager.swift
//  Restarted
//
//  Created by metalWillHelpYou on 11.10.2024.
//

import Foundation
import UserNotifications
import SwiftUI

// Handles in-app and background local notifications
@MainActor
class LocalNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // Apple notification center reference
    let notificationCenter = UNUserNotificationCenter.current()
    // Reactively reflects user permission state
    @Published var isGranted = true
    // Cached list of scheduled requests
    @Published var pendingRequests: [UNNotificationRequest] = []
    
    // Set delegate for foreground delivery callbacks
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    // Requests alert, sound and badge permissions
    func requestAuthorization() async throws {
        try await notificationCenter.requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentSettings()
    }
    
    // Updates `isGranted` after checking current system settings
    func getCurrentSettings() async {
        let settings = await notificationCenter.notificationSettings()
        isGranted = (settings.authorizationStatus == .authorized)
    }
    
    // Opens iOS Settings app on the app-specific page
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        Task { await UIApplication.shared.open(url) }
    }
    
    // Schedules a one-off notification fired after `duration` seconds
    func scheduleTimerEndedNotification(duration: TimeInterval) async {
        let content = UNMutableNotificationContent()
        content.title = "Restarted"
        content.body = "Time is up"
        content.sound = .default
        content.categoryIdentifier = "TIMER_EXPIRED"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duration, repeats: false)
        let request = UNNotificationRequest(identifier: "TimerEnded", content: content, trigger: trigger)
        
        try? await notificationCenter.add(request)
        await getPendingRequests()
    }
    
    // Refreshes `pendingRequests` from the system store
    func getPendingRequests() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
    }
    
    // Removes scheduled request by ID and updates local cache
    func removeRequest(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        if let index = pendingRequests.firstIndex(where: { $0.identifier == identifier }) {
            pendingRequests.remove(at: index)
        }
    }
    
    // Displays banner and sound while app is in foreground
    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
