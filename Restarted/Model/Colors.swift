//
//  Colors.swift
//  Restarted
//
//  Created by metalwillhelpyou on 01.02.2024.
//

import SwiftUI
import Foundation

struct ThemeColors {
    var TextColor: Color
    var backgroundColor: Color
    var tabBarColor: Color
    var sectionColor: Color
    
    static let light = ThemeColors(
        TextColor: Color.black.opacity(0.8),
        backgroundColor: Color(red: 0.949, green: 0.902, blue: 0.812),
        tabBarColor: Color(red: 0.224, green: 0.376, blue: 0.275),
        sectionColor: .white
    )
    
    static let dark = ThemeColors(
        TextColor: Color.white,
        backgroundColor: Color(red: 0.204, green: 0.302, blue: 0.290),
        tabBarColor: Color(red: 0.133, green: 0.239, blue: 0.267),
        sectionColor: .black
    )
    
    //static let system
}

//      backgroundColor: LinearGradient(colors: [Color(red: 0.8, green: 0.9, blue: 0.9), Color(red: 1.0, green: 0.8, blue: 0.8)],
//                                      startPoint: .topLeading, endPoint: .bottomTrailing),

//      backgroundColor: LinearGradient(colors: [Color(red: 0.2, green: 0.2, blue: 0.5), Color(red: 0.4, green: 0.3, blue: 0.6)],
//                                      startPoint: .topLeading, endPoint: .bottomTrailing),
