//
//  AuthenticationView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import SwiftUI
import GoogleSignInSwift

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthentcationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    NavigationLink {
                        SignInWithEmailView(showSignInView: $showSignInView)
                    } label: {
                        Text("Sign In with Email")
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.text)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .strokeBackground(Color.highlight)
                    }
                    
                    GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                        Task {
                            do {
                                try await viewModel.signInGoogle()
                                showSignInView = false
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Sign In")
        }
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
}
