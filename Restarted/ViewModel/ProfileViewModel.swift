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

    func loadCurruntUser() async throws {
        let authDataResult = try AuthenticaitionManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func signOut() throws {
        try AuthenticaitionManager.shared.signOut()
    }
}
