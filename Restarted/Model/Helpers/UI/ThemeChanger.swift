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
        case .light: return Color(.lightIcon)
        case .dark: return Color(.darkIcon)
        }
    }
    
    func setTextColor(with scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault, .light: return Color(.black)
        case .dark: return Color(.white)
        }
    }
    
    func setBackgroundColor(with scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault: return Color(.themeCardBGDefault)
        case .light: return Color(.themeCardBGlight)
        case .dark: return Color(.themeCardBGDark)
        }
    }
    
    func capsuleColor(with scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault, .light: return Color(.white)
        case .dark: return Color(.systemGray5)
        }
    }
}
