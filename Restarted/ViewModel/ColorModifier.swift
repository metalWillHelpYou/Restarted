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
        return content.foregroundColor(themeColors.TextColor)
    }
}

struct BackgroundColorModifier: ViewModifier {
    @AppStorage("selectedTheme") var selectedTheme: Theme = .light
    
    func body(content: Content) -> some View {
        let themeColors = selectedTheme == .light ? ThemeColors.light : ThemeColors.dark
        return content.background(themeColors.backgroundColor)
    }
}

struct TabBarColorModifier {
    static func tabBackgroundColor(for theme: Theme) -> Color {
        switch theme {
        case .light:
            return ThemeColors.light.tabBarColor
        case .dark:
            return ThemeColors.dark.tabBarColor
        }
    }
}

