//
//  ProfileMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ProfileMainScreenView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var root: RootViewModel
    @Binding var activeTab: Tab
    
    var body: some View {
        NavigationStack {
            VStack {
                
                SettingsView(viewModel: viewModel)
                
                AdditionalSettingsView()
                
                logOutButton
                
                Button("Delete account", role: .destructive) {
                    Task {
                        do {
                            try await viewModel.deleteAccount()
                            root.screen = .authentication
                            //ScreenManager.shared.screen = .authentication
                            activeTab = .home
                        } catch {
                            print(error)
                        }
                    }
                }
                
                if let user = viewModel.user {
                    Text("User id: \(user.userId)")
                    
                    if let email = user.email {
                        Text(email)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Profile")
            .background(Color.background)
            .task {
                try? await viewModel.loadCurruntUser()
            }
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
                        root.screen = .authentication
                        //ScreenManager.shared.screen = .authentication
                        activeTab = .home
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
    ProfileMainScreenView(activeTab: .constant(.profile))
}
