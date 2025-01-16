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
}

extension View {
    func strokeBackground(_ color: Color) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(color, lineWidth: 2)
        )
    }
}

extension DateFormatter {
    static let userDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "ru_RU") 
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}

enum SortType: String {
    case byTitle
    case byDateAdded
    case byTime
}

extension NSNotification.Name {
    static let habitsDidChange = NSNotification.Name("habitsDidChange")
}

extension NSNotification.Name {
    static let articlesDidChange = NSNotification.Name("articlesDidChange")
}

extension NSNotification.Name {
    static let gamesDidChange = NSNotification.Name("gamesDidChange")
}

extension NSNotification.Name {
    static let gamePresetsDidChange = NSNotification.Name("gamePresetsDidChange")
}
