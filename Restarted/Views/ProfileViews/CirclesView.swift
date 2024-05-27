//
//  CirclesView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 24.05.2024.
//

import SwiftUI

struct CirclesView: View {
    let strokeColor = ThemeColors.light.tabBarColor
    var body: some View {
        ZStack {
            Circle()
                .stroke(strokeColor, lineWidth: 2)
                .frame(width: 150, height: 150)
            
            Circle()
                .fill(Color.red)
                .frame(width: 148, height: 148)
            
            Circle()
                .stroke(strokeColor, lineWidth: 2)
                .frame(width: 112, height: 112)
            
            Circle()
                .fill(Color.orange)
                .frame(width: 110, height: 110)
            
            Circle()
                .stroke(strokeColor, lineWidth: 2)
                .frame(width: 75, height: 75)
            
            Circle()
                .fill(Color.green)
                .frame(width: 73, height: 73)
            
            Circle()
                .stroke(strokeColor, lineWidth: 2)
                .frame(width: 38, height: 38)
            
            Circle()
                .fill(Color.white)
                .frame(width: 36, height: 36)
        }
    }
}

#Preview {
    CirclesView()
}
