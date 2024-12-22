//
//  ProfileInfoView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.12.2024.
//

import SwiftUI

struct ProfileInfoView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @EnvironmentObject var root: RootViewModel
    @State private var showLogOut: Bool = false
    @State private var showDeleteAccount: Bool = false
    @State private var showChangeName: Bool = false
    @Binding var activeTab: Tab
    
    var body: some View {
        VStack(spacing: 24) {
            userDetailsSection
                .padding(.horizontal)
            
            accountActionsSection
                .padding(.horizontal)
            
            logOutButton
            
            Spacer()
            
            deleteAccountButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .confirmationDialog("Are you sure?", isPresented: $showLogOut, titleVisibility: .visible) {
            logOutConformationButton
        }
        .alert("Delete account", isPresented: $showDeleteAccount) {
            alertButtons
        } message: {
            alertMessage
        }
        .sheet(isPresented: $showChangeName) {
            ChangeNameSheetView()
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Subviews

extension ProfileInfoView {
    private var userDetailsSection: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Email")
                Spacer()
                Text(viewModel.user?.email ?? "Unknown")
            }
            
            HStack {
                Text("Joined")
                Spacer()
                Text(viewModel.formatDateForDisplay(viewModel.user?.dateCreated))
            }
        }
        .padding()
        .strokeBackground(Color.highlight)
    }
    
    private var accountActionsSection: some View {
        VStack(spacing: 24) {
            Button(action: {
                // Action for changing password (not implemented yet)
            }) {
                Text("Change password")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
            }
            
            Button(action: {
                showChangeName.toggle()
            }) {
                Text("Change name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
            }
        }
        .padding()
        .strokeBackground(Color.highlight)
    }
    
    private var logOutButton: some View {
        VStack {
            Button(action: {
                showLogOut.toggle()
            }) {
                Text("Log Out")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
            }
        }
        .padding()
        .strokeBackground(Color.highlight)
        .padding(.horizontal)
    }
    
    private var logOutConformationButton: some View {
        Button("Log out") {
            Task {
                do {
                    try viewModel.signOut()
                    root.screen = .authentication
                    activeTab = .home
                    viewModel.localUserName = ""
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private var deleteAccountButton: some View {
        VStack {
            Button(action: {
                showDeleteAccount.toggle()
            }) {
                Text("Delete account")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
            }
        }
        .padding()
        .strokeBackground(Color.red)
        .padding(.horizontal)
    }
}

extension ProfileInfoView {
    private var alertButtons: some View {
        VStack {
            Button("Cancel", role: .cancel) {
            }
            Button("Delete", role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        root.screen = .authentication
                        //ScreenManager.shared.screen = .authentication
                        activeTab = .home
                        viewModel.localUserName = ""
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    private var alertMessage: some View {
        Text(
            """
            Are you sure you want to delete?
            This action cannot be undone.
            """
        )
    }
}

#Preview {
    ProfileInfoView(activeTab: .constant(.profile))
        .environmentObject(ProfileViewModel())
}
