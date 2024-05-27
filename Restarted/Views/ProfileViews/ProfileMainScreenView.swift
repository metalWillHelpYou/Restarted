//
//  ProfileMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ProfileMainScreenView: View {
    var body: some View {
        NavigationStack {
            VStack {
                StatisticView()
                
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
    ProfileMainScreenView()
}
