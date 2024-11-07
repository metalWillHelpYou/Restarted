//
//  ProfileViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    func signOut() throws {
        try AuthenticaitionManager.shared.signOut()
    }
}
