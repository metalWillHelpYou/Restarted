//
//  TimeTools.swift
//  Restarted
//
//  Created by metalWillHelpYou on 29.12.2024.
//

import Foundation
import SwiftUI

struct TimeTools {
    static func convertSecondsToTime(_ seconds: Int) -> (hours: Int, minutes: Int, seconds: Int) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        return (hours, minutes, remainingSeconds)
    }
    
    static func formatTimeDigits(hours: Int, minutes: Int) -> String {
        hours > 0 ? String(format: "%d:%02d", hours, minutes) : String(format: "%2d", minutes)
    }
    
    static func formatTimeText(hours: Int, minutes: Int) -> LocalizedStringKey {
        var components: [String] = []
        
        if hours > 0 {
            // Простейшая логика для множественного числа
            components.append("\(hours) hour\(hours > 1 ? "s" : "")")
        }
        
        if minutes > 0 {
            components.append("\(minutes) minute\(minutes > 1 ? "s" : "")")
        }
        
        // Склеиваем массив строк...
        let result = components.joined(separator: " ")
        // ...и преобразуем в LocalizedStringKey
        return LocalizedStringKey(result)
    }
    
    static func convertSecondsToHours(_ seconds: Int) -> Int {
        let hours = seconds / 3600
        return hours
    }
    
    static func convertSecondsToHoursMinutes(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}
