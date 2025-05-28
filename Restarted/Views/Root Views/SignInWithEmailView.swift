//
//  SignInWithEmailView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 07.11.2024.
//

import SwiftUI

struct SignInWithEmailView: View {
    @StateObject var viewModel = SignInWithEmailViewModel()
    @EnvironmentObject var root: RootViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Text("Sign In")
                    .font(.largeTitle)
                    .foregroundStyle(Color.highlight)
                    .padding(.vertical)
                
                TextField("Email", text: $viewModel.email)
                    .withTextFieldModifires()
                    .padding()

                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(viewModel.tip)
                    .foregroundStyle(Color.highlight)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signUp()
                            root.screen = .content
                        } catch {
                            print("Sign Up Error: \(error)")
                        }
                        
                        do {
                            try await viewModel.signIn()
                            root.screen = .content
                        } catch {
                            print("Sign In Error: \(error)")
                        }
                    }
                }, label: {
                    Text("Sign In")
                        .withAnimatedButtonFormatting(viewModel.isButtonEnabled)
                })
                .disabled(!viewModel.isButtonEnabled)
                .padding(.top, 56)
            }
        }
    }
}

#Preview {
    SignInWithEmailView()
}
