//
//  GamesMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.05.2024.
//

import SwiftUI

struct GamesMainScreenView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @StateObject private var loadFromJSON = DataLoaderFromJSON<Game>(filename: "games")
    @State private var isSetTimePresented = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(loadFromJSON.items) { game in
                        Button(action: {
                            isSetTimePresented = true
                            print("Game \(game.title) selected")
                        }) {
                            GameCardView(game: game)
                                .contentShape(RoundedRectangle(cornerRadius: 15))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.vertical, 4)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .sheet(isPresented: $isSetTimePresented, content: {
                    SetGameTimerView()
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                })
            }
            .navigationTitle("Games")
            .background(Color.background)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
        }
        .preferredColorScheme(userTheme.setTheme)
    }
}

#Preview {
    GamesMainScreenView()
}
