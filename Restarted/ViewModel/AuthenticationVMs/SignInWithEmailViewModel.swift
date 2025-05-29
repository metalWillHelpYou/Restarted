//
//  SignInWithEmailViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import Foundation

// View model for email/password authentication
@MainActor
final class SignInWithEmailViewModel: ObservableObject {
    // Email entered by user
    @Published var email = "" {
        didSet { validateInputs() }
    }
    // Password entered by user
    @Published var password = "" {
        didSet { validateInputs() }
    }
    // Controls submit button availability
    @Published var isButtonEnabled = false
    // Helper text shown under fields
    @Published var tip: String = "Enter a valid email and password (6+ characters)"
    
    // Registers new account and creates Firestore user
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else { return }
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createUser(user: user)
    }
    
    // Logs user into Firebase
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else { return }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
    // Enables button only when inputs are valid
    private func validateInputs() {
        if email.isValidEmail && password.count >= 6 {
            isButtonEnabled = true
        } else {
            isButtonEnabled = false
        }
    }
}

// Regex based email validation
extension String {
    var isValidEmail: Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
}
