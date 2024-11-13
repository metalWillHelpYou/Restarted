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
        
        let authDataResult = try await AuthenticaitionManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createUser(auth: authDataResult)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        try await AuthenticaitionManager.shared.signInUser(email: email, password: password)
    }
}
