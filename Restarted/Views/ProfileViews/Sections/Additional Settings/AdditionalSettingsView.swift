//
//  AdditionalSettingsView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 24.05.2024.
//

import SwiftUI
import MarkdownUI

struct AdditionalSettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            NavigationLink(destination: QuickGuideView()) {
                Text("Quick guide")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Text("Restarted FAQ")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .strokeBackground(Color.highlight)
        .foregroundStyle(Color.primary)
        .padding(.horizontal)
        .padding(.top, 40)
    }
}

#Preview {
    AdditionalSettingsView()
}
