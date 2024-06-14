//
//  Extentions.swift
//  Restarted
//
//  Created by metalWillHelpYou on 06.06.2024.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func strokeBacground() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.highlight, lineWidth: 2)
        )
    }
}
