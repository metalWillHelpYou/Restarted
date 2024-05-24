//
//  CirclesView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 24.05.2024.
//

import SwiftUI

struct CirclesView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 15)
                .stroke(ThemeColors.light.tabBarColor, lineWidth: 2)
                .frame(height: 182)
                .padding(.horizontal)
                .padding(.top)
        }
    }
}

#Preview {
    CirclesView()
}
