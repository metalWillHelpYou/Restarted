//
//  SignInGoogleHelper.swift
//  Restarted
//
//  Created by metalWillHelpYou on 08.11.2024.
//

import Foundation
import GoogleSignIn

final class SignInGoogleHelper {
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilites.shared.topViewController() else {
            throw URLError(.timedOut)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        return tokens
    }
}
