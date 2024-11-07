//
//  SignInWithEmailViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import Foundation

@MainActor
final class SignInWithEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        _ = try await AuthenticaitionManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        _ = try await AuthenticaitionManager.shared.signInUser(email: email, password: password)
    }
}
