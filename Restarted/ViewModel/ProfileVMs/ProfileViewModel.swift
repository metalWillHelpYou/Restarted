//
//  ProfileViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import Foundation
import SwiftUI

// Manages user profile data and settings
@MainActor
final class ProfileViewModel: ObservableObject {
    // User record fetched from Firestore
    @Published var user: DBUser? = nil
    // Text field binding for editing display name
    @Published var newNameHandler: String = ""
    // Local toggle synced with Firestore notification flag
    @AppStorage("isNotificationsOn") var isNotificationsOn: Bool = false
    // Local copy of user display name for faster UI access
    @AppStorage("localUserName") var localUserName: String = ""

    // Loads authenticated user and updates published properties
    func loadCurrentUser() async throws {
        let auth = try AuthenticationManager.shared.getAuthenticatedUser()
        let fetched = try await UserManager.shared.getUser(userId: auth.uid)
        updateUserState(with: fetched)
    }
    
    // Switches notification preference and persists to Firestore
    func toggleNotifications() {
        guard let user else { return }
        isNotificationsOn.toggle()
        Task {
            do {
                try await UserManager.shared.updateUserNotificationsStatus(userId: user.userId, isNotificationsOn: isNotificationsOn)
            } catch {
                revertNotificationsToggle()
                print("Failed to update notifications status: \(error)")
            }
        }
    }
    
    // Saves new display name to Firestore and resets input
    func changeUserName() {
        guard let user else { return }
        localUserName = newNameHandler
        Task {
            do {
                try await UserManager.shared.updateUserName(userId: user.userId, name: localUserName)
                newNameHandler = ""
            } catch {
                print("Error updating user name: \(error)")
            }
        }
    }
    
    // Signs user out of Firebase
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    // Deletes Firebase account and related data
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.deleteUser()
    }
    
    // Returns localized greeting based on current hour
    func generateGreeting() -> LocalizedStringKey {
        let hour = Calendar.current.component(.hour, from: Date())
        return greetingMessage(for: hour)
    }
    
    // Formats optional date for display
    func formatDateForDisplay(_ date: Date?) -> String {
        guard let date else { return "Date is empty" }
        return DateFormatter.userDateFormatter.string(from: date)
    }
    
    // Updates published properties after fetching user document
    private func updateUserState(with fetchedUser: DBUser) {
        DispatchQueue.main.async {
            self.user = fetchedUser
            self.isNotificationsOn = fetchedUser.isNotificationsOn ?? false
            self.syncLocalUserNameIfNeeded(with: fetchedUser.name)
        }
    }
    
    // Ensures local cache matches Firestore value
    private func syncLocalUserNameIfNeeded(with name: String?) {
        guard let name, localUserName != name else { return }
        localUserName = name
    }
    
    // Reverts toggle when Firestore update fails
    private func revertNotificationsToggle() {
        DispatchQueue.main.async { self.isNotificationsOn.toggle() }
    }
    
    // Hour-based greeting message
    private func greetingMessage(for hour: Int) -> LocalizedStringKey {
        switch hour {
        case 6...12: return "Good morning,"
        case 13...18: return "Good day,"
        case 19...23: return "Good evening,"
        default: return "Good night,"
        }
    }
    
    // Copies default articles into user sub-collection
    func loadArticles() {
        Task {
            do {
                if let user = user {
                    try await UserManager.shared.initializeUserArticles(for: user.userId)
                }
            } catch {
                print("Error initializing articles: \(error)")
            }
        }
    }
}
