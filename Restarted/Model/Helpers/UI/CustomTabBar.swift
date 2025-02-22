//
//  CustomTabBar.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.06.2024.
//

import Foundation
import SwiftUI

struct CustomTabBar: View {
    @Binding var activeTab: Tab
    @Binding var allTabs: [AnimatedTab]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                        .symbolEffect(.bounce.up.byLayer, value: animatedTab.isAnimated)
                    
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
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete, {
                        activeTab = tab
                        animatedTab.isAnimated = true
                    }, completion: {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animatedTab.isAnimated = nil
                        }
                    })
                }
            }
        }
        .background(Color.background)
    }
}

extension View {
    @ViewBuilder
    func setupTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
    }
}

enum Tab: String, CaseIterable {
    case practice = "list.bullet"
    case articles = "doc.plaintext"
    case games = "gamecontroller"
    case stats = "chart.bar"
    case profile = "person"
    
    var title: LocalizedStringKey {
        switch self {
        case .practice: return "Practice"
        case .articles: return "Articles"
        case .games: return "Games"
        case .stats: return "Statistics"
        case .profile: return "Profile"
        }
    }
}

struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimated: Bool?
}
