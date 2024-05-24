//
//  ProfileView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack {
                CirclesView()
                
                SettingsView()

                AdditionalSettingsView()
                
                Spacer()
            }
            .navigationTitle("Profile")
            .themedModifiers()
        }
    }
}

#Preview {
    ProfileView()
}
