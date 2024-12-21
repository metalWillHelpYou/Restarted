//
//  ProfileMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ProfileMainScreenView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Binding var activeTab: Tab
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 36) {
                NavigationLink(destination: ProfileInfoView(activeTab: $activeTab)) {
                    ProfileInfoLinkView()
                }
                
                SettingsView(viewModel: viewModel)
                
                igdTests
                
                AdditionalSettingsView()
                
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
    private var igdTests: some View {
        VStack(alignment: .leading, spacing: 24) {
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
    }
}

#Preview {
    ProfileMainScreenView(activeTab: .constant(.profile))
        .environmentObject(ProfileViewModel())
}
