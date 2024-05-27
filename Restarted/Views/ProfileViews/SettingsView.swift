//
//  SettingsView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 24.05.2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedTheme") private var selectedTheme: Theme = .light
    
    var isDarkModeEnabled: Bool {
        get { selectedTheme == .dark }
        set { selectedTheme = newValue ? .dark : .light }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Schedule")
            
            Text("Privacy and Security")
            
            Text("Export diary")
            
            Text("Language")
            
            Toggle("Dark Mode", isOn: Binding(
                get: { selectedTheme == .dark },
                set: { selectedTheme = $0 ? .dark : .light }
            ))
            .toggleStyle(SwitchToggleStyle(tint: .green))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(ThemeColors.light.tabBarColor, lineWidth: 2)
        )
        .padding(.horizontal)
        .padding(.top, 40)
    }
}

#Preview {
    SettingsView()
}
