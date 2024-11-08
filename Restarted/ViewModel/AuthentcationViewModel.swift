//
//  AuthentcationViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 08.11.2024.
//

import Foundation

@MainActor
final class AuthentcationViewModel: ObservableObject {
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticaitionManager.shared.signInWithGoogle(tokens: tokens)
    }
}
