//
//  AdditionalSettingsView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 24.05.2024.
//

import SwiftUI

struct AdditionalSettingsView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 15)
                .stroke(ThemeColors.light.tabBarColor, lineWidth: 2)
                .frame(height: 78)
                .padding(.top, 40)
                .padding(.horizontal)
        }
    }
}

#Preview {
    AdditionalSettingsView()
}
