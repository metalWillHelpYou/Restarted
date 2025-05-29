//
//  Extensions.swift
//  Restarted
//
//  Created by metalWillHelpYou on 06.06.2024.
//

import Foundation
import SwiftUI

// MARK: - View helpers

// Dismisses the keyboard by resigning the first responder
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Adds a rounded rectangle stroke around the view's background
extension View {
    func strokeBackground(_ color: Color) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(color, lineWidth: 2)
        )
    }
}

// MARK: - Date formatting

// Shared formatter for displaying dates in *dd.MM.yyyy* format
extension DateFormatter {
    static let userDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}

// MARK: - Sorting options

// Enumerates available sorting strategies for lists
enum SortType: String {
    case byTitle
    case byDateAdded
    case byTime
}

// MARK: - Notification names

// App‑wide change notifications
extension NSNotification.Name {
    static let practicesDidChange = NSNotification.Name("practicesDidChange")
    static let articlesDidChange  = NSNotification.Name("articlesDidChange")
    static let gamesDidChange     = NSNotification.Name("gamesDidChange")
    static let gamePresetsDidChange = NSNotification.Name("gamePresetsDidChange")
}
