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
    case home = "list.bullet"
    case articles = "doc.plaintext"
    case games = "gamecontroller"
    case diary = "book.pages"
    case profile = "person"
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .articles: return "Articles"
        case .games: return "Games"
        case .diary: return "Diary"
        case .profile: return "Profile"
        }
    }
}

struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimated: Bool?
}
