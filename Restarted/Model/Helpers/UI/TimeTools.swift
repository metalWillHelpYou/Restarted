//
//  TimeTools.swift
//  Restarted
//
//  Created by metalWillHelpYou on 29.12.2024.
//

import Foundation
import SwiftUI

// Utility conversions between raw seconds and formatted time values
struct TimeTools {
    // Splits total seconds into (h, m, s) components
    static func convertSecondsToTime(_ seconds: Int) -> (hours: Int, minutes: Int, seconds: Int) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        return (hours, minutes, remainingSeconds)
    }
    
    // Returns a digital clock style string like "1:05" or "05"
    static func formatTimeDigits(hours: Int, minutes: Int) -> String {
        hours > 0 ? String(format: "%d:%02d", hours, minutes) : String(format: "%2d", minutes)
    }
    
    // Builds an description
    static func formatTimeText(hours: Int, minutes: Int) -> LocalizedStringKey {
        var parts: [String] = []
        if hours > 0 {
            parts.append("\(hours) hour\(hours > 1 ? "s" : "")")
        }
        if minutes > 0 {
            parts.append("\(minutes) minute\(minutes > 1 ? "s" : "")")
        }
        return LocalizedStringKey(parts.joined(separator: " "))
    }
    
    // Converts seconds to whole hours discarding remainder
    static func convertSecondsToHours(_ seconds: Int) -> Int {
        seconds / 3600
    }
    
    // Converts seconds to "HH:MM" string
    static func convertSecondsToHoursMinutes(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}
