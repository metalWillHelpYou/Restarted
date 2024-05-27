//
//  AdditionalSettingsView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 24.05.2024.
//

import SwiftUI

struct AdditionalSettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Restarted FAQ")
            
            Text("Restarted Features")
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
    AdditionalSettingsView()
}
