//
//  ProfileViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published var isNotificationsOn: Bool = false

    func loadCurruntUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
    }
    
    func toggleNotifications() {
        guard var user else { return }
        user.toggleNotificationStatus()
        Task {
            try UserManager.shared.updateUserNotificationsStatus(user: user)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}

