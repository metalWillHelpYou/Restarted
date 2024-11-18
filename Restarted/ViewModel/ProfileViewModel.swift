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
        isNotificationsOn = self.user?.isNotificationsOn ?? false
    }
    
    func toggleNotifications() {
        guard let user else { return }
        let currentValue = user.isNotificationsOn ?? false
        Task {
            try await UserManager.shared.updateUserNotificationsStatus(userId: user.userId, isNotificationsOn: !currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.deleteUser()
    }
}

