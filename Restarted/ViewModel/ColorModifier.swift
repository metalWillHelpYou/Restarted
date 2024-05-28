//
//  ThemeModifier.swift
//  Restarted
//
//  Created by metalwillhelpyou on 14.02.2024.
//

import SwiftUI

struct TextModifier: ViewModifier {
    @AppStorage("selectedTheme") var selectedTheme: Theme = .light
    
    func body(content: Content) -> some View {
        let themeColors = selectedTheme == .light ? ThemeColors.light : ThemeColors.dark
        return content.foregroundColor(themeColors.textColor)
    }
}

struct BackgroundColorModifier: ViewModifier {
    @AppStorage("selectedTheme") var selectedTheme: Theme = .light
    
    func body(content: Content) -> some View {
        let themeColors = selectedTheme == .light ? ThemeColors.light : ThemeColors.dark
        return content.background(themeColors.backgroundColor)
    }
}

struct StrokeModifier: ViewModifier {
    @AppStorage("selectedTheme") var selectedTheme: Theme = .light
    
    func body(content: Content) -> some View {
        let themeColors = selectedTheme == .light ? ThemeColors.light : ThemeColors.dark
        return content.overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(themeColors.primaryColor, lineWidth: 2)
        )
    }
}

struct PrimaryColorModifier {
    static func primaryColor(for theme: Theme) -> Color {
        switch theme {
        case .light:
            return ThemeColors.light.primaryColor
        case .dark:
            return ThemeColors.dark.primaryColor
        }
    }
}

struct CustomNavigationTitle: ViewModifier {
    var title: String
    
    func body(content: Content) -> some View {
        content
            .padding(.top, 52)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 92)
                            .themedText()
                }
            }
    }
}
