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
    
    func loadCurruntUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        let fetchedUser = try await UserManager.shared.getUser(userId: authDataResult.uid)

        DispatchQueue.main.async {
            if self.user != fetchedUser {
                self.user = fetchedUser
                self.isNotificationsOn = fetchedUser.isNotificationsOn ?? false
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
}

