//
//  ProfileMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ProfileMainScreenView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    var body: some View {
        NavigationStack {
            VStack {
                StatisticView()
                
                SettingsView()
                
                AdditionalSettingsView()
                
                Spacer()
            }
            .navigationTitle("Profie")
            .background(Color.background)
        }
        .preferredColorScheme(userTheme.colorTheme)
    }
}

#Preview {
    ProfileMainScreenView()
}
