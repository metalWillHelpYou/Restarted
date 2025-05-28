//
//  ProfileViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import Foundation
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var user: DBUser? = nil
    @Published var newNameHandler: String = ""
    @AppStorage("isNotificationsOn") var isNotificationsOn: Bool = false
    @AppStorage("localUserName") var localUserName: String = ""

    // MARK: - Public Methods

    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        let fetchedUser = try await UserManager.shared.getUser(userId: authDataResult.uid)

        updateUserState(with: fetchedUser)
    }
    
    func toggleNotifications() {
        guard let user else { return }
        
        isNotificationsOn.toggle()

        Task {
            do {
                try await UserManager.shared.updateUserNotificationsStatus(
                    userId: user.userId,
                    isNotificationsOn: isNotificationsOn
                )
            } catch {
                revertNotificationsToggle()
                print("Failed to update notifications status: \(error)")
            }
        }
    }
    
    func changeUserName() {
         guard let user else { return }
         
         localUserName = newNameHandler

         Task {
             do {
                 try await UserManager.shared.updateUserName(
                     userId: user.userId,
                     name: localUserName
                 )
                 newNameHandler = ""
             } catch {
                 print("Error while updating user name: \(error)")
             }
         }
     }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.deleteUser()
    }
    
    func generateGreeting() -> LocalizedStringKey {
        let hour = Calendar.current.component(.hour, from: Date())
        return greetingMessage(for: hour)
    }
    
    func formatDateForDisplay(_ date: Date?) -> String {
        guard let date = date else { return "Date is empty" }
        return DateFormatter.userDateFormatter.string(from: date)
    }

    // MARK: - Private Methods

    private func updateUserState(with fetchedUser: DBUser) {
        DispatchQueue.main.async {
            self.user = fetchedUser
            self.isNotificationsOn = fetchedUser.isNotificationsOn ?? false
            self.syncLocalUserNameIfNeeded(with: fetchedUser.name)
        }
    }
    
    private func syncLocalUserNameIfNeeded(with name: String?) {
        guard let name, localUserName != name else { return }
        localUserName = name
    }
    
    private func revertNotificationsToggle() {
        DispatchQueue.main.async { self.isNotificationsOn.toggle() }
    }
    
    private func greetingMessage(for hour: Int) -> LocalizedStringKey {
        switch hour {
        case 6...12: return "Good morning,"
        case 13...18: return "Good day,"
        case 19...23: return "Good evening,"
        default: return "Good night,"
        }
    }
    
    func loadArticles() {
        Task {
            do {
                if let user = user {
                    try await UserManager.shared.initializeUserArticles(for: user.userId)
                }
            } catch {
                print("error")
            }
        }
    }
}
