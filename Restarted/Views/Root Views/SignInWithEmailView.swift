//
//  SignInWithEmailView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import SwiftUI

struct SignInWithEmailView: View {
    @StateObject var viewModel = SignInWithEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .foregroundStyle(Color.text)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signUp()
                            showSignInView = false
                            return
                        } catch {
                            print(error)
                        }
                        
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            return
                        } catch {
                            print(error)
                        }
                    }
                }, label: {
                    Text("Sign In")
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.text)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .strokeBackground(Color.highlight)
                })
                .padding(.vertical, 32)
                
                Spacer()
            }
            .navigationTitle("Sign In")
            .padding(.horizontal)
            .background(Color.background)
        }
    }
}

#Preview {
    SignInWithEmailView(showSignInView: .constant(false))
}
