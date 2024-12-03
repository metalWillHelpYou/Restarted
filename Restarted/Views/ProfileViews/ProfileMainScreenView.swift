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
    @State private var showLogOut: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                SettingsView(viewModel: viewModel)
                
                igdTests
                
                AdditionalSettingsView()
                
                logOutButton
                
                //deleteAccountButton
                
                Spacer()
            }
            .navigationTitle("Profile")
            .background(Color.background)
            .task {
                try? await viewModel.loadCurruntUser()
            }
            .confirmationDialog("Are you sure?", isPresented: $showLogOut, titleVisibility: .visible) {
                logOutConformationButton
            }
        }
    }
}

extension ProfileMainScreenView {
    private var logOutButton: some View {
        VStack {
            Button(action: {
                showLogOut.toggle()
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
    
    private var logOutConformationButton: some View {
        Button("Log Out") {
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
        }
    }
    
    private var igdTests: some View {
        VStack(alignment: .leading, spacing: 16) {
            NavigationLink(destination: IGDTestInfoView(testType: .longTest)) {
                Text("Internet Gaming Disorder test")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            NavigationLink(destination: IGDTestInfoView(testType: .shortTest)) {
                Text("Short Internet Gaming Disorder test")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .foregroundStyle(Color.primary)
        .padding()
        .strokeBackground(Color.highlight)
        .padding(.horizontal)
        .padding(.top, 40)
        
    }
    
    private var deleteAccountButton: some View {
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
    }
}

#Preview {
    ProfileMainScreenView(activeTab: .constant(.profile))
}
