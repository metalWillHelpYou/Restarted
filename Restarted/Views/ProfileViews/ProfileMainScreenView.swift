//
//  ProfileMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ProfileMainScreenView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSigInView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                
                SettingsView()
                
                AdditionalSettingsView()
                
                logOutButton
                
                Spacer()
            }
            .navigationTitle("Profile")
            .background(Color.background)
        }
    }
}

extension ProfileMainScreenView {
    private var logOutButton: some View {
        VStack {
            Button(action: {
                Task {
                    do {
                        try viewModel.signOut()
                        showSigInView = true
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                Text("Log Out")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
            })
        }
        .padding()
        .strokeBackground(Color.highlight)
        .padding(.horizontal)
        .padding(.top, 40)
    }
}

#Preview {
    ProfileMainScreenView(showSigInView: .constant(false))
}
