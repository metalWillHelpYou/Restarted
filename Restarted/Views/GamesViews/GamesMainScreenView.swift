//
//  GamesMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.05.2024.
//

import SwiftUI

struct GamesMainScreenView: View {
    @AppStorage("selectedTheme") private var selectedTheme: Theme = .light
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
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                            Text("What are you playing today?")
                                .font(.title2)
                                .bold()
                                .themedText()
                    }
                }
                .sheet(isPresented: $isSetTimePresented, content: {
                    SetGameTimerView()
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                    
                })
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(NavBarColorModifier.primaryColor(for: selectedTheme), for: .navigationBar)
            .themedModifiers()
        }
    }
}

#Preview {
    GamesMainScreenView()
}
