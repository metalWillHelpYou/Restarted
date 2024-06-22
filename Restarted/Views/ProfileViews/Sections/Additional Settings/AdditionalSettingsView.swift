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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .strokeBacground()
        .padding(.horizontal)
        .padding(.top, 40)
    }
}

#Preview {
    AdditionalSettingsView()
}