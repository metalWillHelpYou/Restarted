//
//  SignInWithEmailViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import Foundation

@MainActor
final class SignInWithEmailViewModel: ObservableObject {
    @Published var email = "" {
        didSet { validateInputs() }
    }
    @Published var password = "" {
        didSet { validateInputs() }
    }
    @Published var isButtonEnabled = false
    @Published var tip: String = "Enter a valid email and password (6+ characters)"
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createUser(user: user)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
    private func validateInputs() {
        if email.isValidEmail && password.count >= 6 {
            isButtonEnabled = true
        } else {
            isButtonEnabled = false
        }
    }
}

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}

