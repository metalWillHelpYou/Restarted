//
//  ThemeChanger.swift
//  Restarted
//
//  Created by metalWillHelpYou on 04.06.2024.
//

import SwiftUI

enum Theme: String, CaseIterable {
    case systemDefault = "Default"
    case light = "Light"
    case dark = "Dark"
    
    var setTheme: ColorScheme? {
        switch self {
        case .systemDefault: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    func setIconColor(with scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault: return Color(.systemBlue)
        case .light: return .lightIcon
        case .dark: return .darkIcon
        }
    }
    
    func setTextColor(with scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault, .light: return .black
        case .dark: return .white
        }
    }
    
    func setBackgroundColor(with scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault: return Color(.systemBackground)
        case .light: return .themeCardBGlight
        case .dark: return .themeCardBGDark
        }
    }
}
