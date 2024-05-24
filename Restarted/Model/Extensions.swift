//
//  Extensions.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

extension View {
    func themedText() -> some View {
        self.modifier(TextModifier())
    }
    
    func themedBackground() -> some View {
        self.modifier(BackgroundColorModifier())
    }
    
    func themedModifiers() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .themedText()
            .themedBackground()
    }
}
