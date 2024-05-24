//
//  SettingsView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 24.05.2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 15)
                .stroke(ThemeColors.light.tabBarColor, lineWidth: 2)
                .frame(height: 230)
                .padding(.top, 40)
                .padding(.horizontal)
            
            Text("Schedule")
                .font(.body)
                .fontWeight(.bold)
                .padding(.top, 55)
                .padding(.leading, 32)
        }
    }
}

#Preview {
    SettingsView()
}
