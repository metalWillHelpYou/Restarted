//
//  GamesMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.05.2024.
//

import SwiftUI

struct GamesMainScreenView: View {
    @StateObject private var loadFromJSON = DataLoaderFromJSON<Game>(filename: "games")
    @State private var isSetTimePresented = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
                .sheet(isPresented: $isSetTimePresented, content: {
                    SetGameTimerView()
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                    
                })
                .padding(.horizontal)
                .navigationTitle("It's time to play")
    
            }
            .themedModifiers()
        }
    }
}

#Preview {
    GamesMainScreenView()
}

//FIXME: какая то хуйня с кнопками
