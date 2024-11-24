//
//  AuthentcationViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 08.11.2024.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
        let userId = authDataResult.uid
        let existingUser = try? await UserManager.shared.getUser(userId: userId)
        
        if existingUser == nil {
            let newUser = DBUser(auth: authDataResult)
            try await UserManager.shared.createUser(user: newUser)
        }
    }
}

