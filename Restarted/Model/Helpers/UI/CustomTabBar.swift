//
//  CustomTabBar.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.06.2024.
//

import Foundation
import SwiftUI

// Animated bottom navigation bar
struct CustomTabBar: View {
    // Currently selected tab
    @Binding var activeTab: Tab
    // All tabs with per-item animation state
    @Binding var allTabs: [AnimatedTab]
    
    var body: some View {
        HStack(spacing: 0) {
            // One button per tab
            ForEach($allTabs) { $animated in
                let tab = animated.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                        .symbolEffect(.bounce.up.byLayer, value: animated.isAnimated)
                    
                    Text(tab.title)
                        .font(.caption2)
                        .textScale(.secondary)
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(activeTab == tab ? Color.highlight : Color.gray.opacity(0.7))
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    // Trigger bounce and switch tabs
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete, {
                        activeTab = tab
                        animated.isAnimated = true
                    }, completion: {
                        var tx = Transaction()
                        tx.disablesAnimations = true
                        withTransaction(tx) { animated.isAnimated = nil }
                    })
                }
            }
        }
        .background(Color.background)
    }
}

// Helper to expand view and tag it for TabView selection
extension View {
    @ViewBuilder
    func setupTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
    }
}

// Available sections in the app with SF Symbol names
enum Tab: String, CaseIterable {
    case practice  = "list.bullet"
    case articles  = "doc.plaintext"
    case games     = "gamecontroller"
    case stats     = "chart.bar"
    case profile   = "person"
    
    // Localized label shown under icon
    var title: LocalizedStringKey {
        switch self {
        case .practice: return "Practice"
        case .articles: return "Articles"
        case .games:    return "Games"
        case .stats:    return "Statistics"
        case .profile:  return "Profile"
        }
    }
}

// Model backing each tab item in the bar
struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimated: Bool?
}
