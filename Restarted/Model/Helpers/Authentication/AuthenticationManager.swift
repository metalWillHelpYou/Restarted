//
//  AuthenticationManager.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import Foundation
import FirebaseAuth

// Provides all authentication‑related Firebase operations
final class AuthenticationManager {
    // Singleton instance
    static let shared = AuthenticationManager()
    private init() { }
    
    // Returns the currently signed‑in user or throws if none
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    // Signs the current user out of Firebase
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

// Email & password flow
extension AuthenticationManager {
    // Creates a new Firebase account and returns its model
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: result.user)
    }
    
    // Authenticates an existing user with email and password
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: result.user)
    }
    
    // Sends a password‑reset email
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // Updates the password for the current user
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else { throw URLError(.unknown) }
        try await user.updatePassword(to: password)
    }
    
    // Sends a verification email before changing the address
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else { throw URLError(.unknown) }
        try await user.sendEmailVerification(beforeUpdatingEmail: email)
    }
    
    // Deletes user data in Firestore and the Firebase account
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else { throw URLError(.unknown) }
        let userId = user.uid
        do {
            try await UserManager.shared.deleteUserDocument(userId: userId)
            try await user.delete()
            print("User data deleted successfully")
        } catch {
            print("Error while deleting user: \(error.localizedDescription)")
            throw error
        }
    }
}

// SSO flow
extension AuthenticationManager {
    // Signs in through Google‑issued ID and access tokens
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signInWith(credential: credential)
    }
    
    // Generic credential‑based sign‑in
    func signInWith(credential: AuthCredential) async throws -> AuthDataResultModel {
        let result = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: result.user)
    }
}

// Top‑level navigation targets
enum Screen {
    case authentication
    case content
}
