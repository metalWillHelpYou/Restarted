//
//  PlusButton.swift
//  Restarted
//
//  Created by metalWillHelpYou on 18.08.2024.
//

import SwiftUI

struct PlusButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.highlight, lineWidth: 2)
                .frame(width: 30, height: 30)
            
            Image(systemName: "plus")
                .foregroundColor(Color.highlight)
                .font(.system(size: 20))
        }
    }
}

#Preview {
    PlusButton()
}
