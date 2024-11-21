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
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .keyboardType(.emailAddress)
                
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
                            //ScreenManager.shared.screen = .content
                        } catch {
                            print("Sign Up Error: \(error)")
                        }
                        
                        do {
                            try await viewModel.signIn()
                            root.screen = .content
                            //ScreenManager.shared.screen = .content
                        } catch {
                            print("Sign In Error: \(error)")
                        }
                    }
                }, label: {
                    Text("Sign In")
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(viewModel.isButtonEnabled ? Color.text : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .strokeBackground(viewModel.isButtonEnabled ? Color.highlight : Color.gray.opacity(0.4))
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
