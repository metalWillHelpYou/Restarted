//
//  AuthenticationView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import SwiftUI
import GoogleSignInSwift

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @EnvironmentObject var root: RootViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    SignInWithEmailView()
                    
                    CustomGoogleSignInButton {
                        Task {
                            do {
                                try await viewModel.signInGoogle()
                                root.screen = .content
                            } catch {
                                print("Google Sign In Error: \(error)")
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    AuthenticationView()
}

struct CustomGoogleSignInButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image("googleIcon")
                    .resizable()
                    .frame(width: 24, height: 24)
                    
                Text("Sign in with Google")
                    .foregroundColor(.black)
                    .padding(.leading, 8)
            }
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
        }
    }
}
