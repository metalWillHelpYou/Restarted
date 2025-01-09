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

