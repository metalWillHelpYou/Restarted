//
//  AuthenticationView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
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
                .padding(.horizontal)
            }
            .navigationTitle("Sign In")
        }
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
}
