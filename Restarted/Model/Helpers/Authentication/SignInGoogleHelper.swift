//
//  SignInGoogleHelper.swift
//  Restarted
//
//  Created by metalWillHelpYou on 08.11.2024.
//

import Foundation
import GoogleSignIn

// Wraps the Google Sign‑In SDK in an async helper
final class SignInGoogleHelper {
    // Launches the Google flow and returns OAuth tokens
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        // Find the topmost view controller to present the Google sheet
        guard let topVC = Utilites.shared.topViewController() else {
            throw URLError(.timedOut)
        }
        
        // Perform the sign‑in request
        let gidResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        // Extract ID and access tokens
        guard let idToken = gidResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = gidResult.user.accessToken.tokenString
        
        // Package tokens into a model object
        return GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
    }
}
