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
    @Published private(set) var user: DBUser? = nil
    @AppStorage("isNotificationsOn") var isNotificationsOn: Bool = false
    @AppStorage("localUserName") var localUserName: String = ""
    
    func loadCurruntUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        let fetchedUser = try await UserManager.shared.getUser(userId: authDataResult.uid)

        DispatchQueue.main.async {
            if self.user != fetchedUser {
                self.user = fetchedUser
                self.isNotificationsOn = fetchedUser.isNotificationsOn ?? false
                
                if let name = fetchedUser.name, self.localUserName != name {
                    self.localUserName = name
                }
            }
        }
    }
    
    func toggleNotifications() {
        guard let user else { return }

        // Local update
        isNotificationsOn.toggle()

        Task {
            do {
                // Sending the updated status to Firebase
                try await UserManager.shared.updateUserNotificationsStatus(
                    userId: user.userId,
                    isNotificationsOn: isNotificationsOn
                )

                // After a successful update, we synchronize with the database
                let updatedUser = try await UserManager.shared.getUser(userId: user.userId)
                DispatchQueue.main.async {
                    self.user = updatedUser
                    self.isNotificationsOn = updatedUser.isNotificationsOn ?? false
                }
            } catch {
                // In case of an error, we return the previous state
                DispatchQueue.main.async {
                    self.isNotificationsOn.toggle()
                }
                print("Ошибка обновления уведомлений: \(error)")
            }
        }
    }

    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.deleteUser()
    }
    
    func generateGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 7..<10:
            return "Good morning"
        case 11..<17:
            return "Good day"
        case 18..<22:
            return "Good evening"
        default:
            return "Good night"
        }
    }
    
    func formatDateForDisplay(_ date: Date?) -> String {
        guard let date = date else {
            return "Data is empty"
        }
        return DateFormatter.userDateFormatter.string(from: date)
    }
    
    
    private func localUserNameChanger() async throws {
        guard let user = user, let name = user.name else { return }
        if localUserName != name {
            DispatchQueue.main.async {
                self.localUserName = name
            }
        }
    }
}
