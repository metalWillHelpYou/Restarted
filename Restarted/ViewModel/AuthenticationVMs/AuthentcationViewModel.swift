//
//  AuthentcationViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 08.11.2024.
//

import Foundation

// View model handling user sign-in flows
@MainActor
final class AuthenticationViewModel: ObservableObject {
    // Initiates Google OAuth, signs in to Firebase and creates user document if needed
    func signInGoogle() async throws {
        // Present Google sign-in sheet and obtain OAuth tokens
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        // Exchange tokens for Firebase credentials
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
        // Check whether Firestore user already exists
        let userId = authDataResult.uid
        let existingUser = try? await UserManager.shared.getUser(userId: userId)
        
        // Create initial user record when first login occurs
        if existingUser == nil {
            let newUser = DBUser(auth: authDataResult)
            try await UserManager.shared.createUser(user: newUser)
        }
    }
}
