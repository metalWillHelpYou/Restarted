//
//  GamesMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.05.2024.
//

import SwiftUI

struct GamesMainScreenView: View {
    @State private var games: [GameUD] = UserDefaults.standard.loadGames()
    @State private var isSetTimePresented = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
//                ForEach(games) { game in
//                    NavigationLink(destination: SetGameTimerView()) {
//                        GameCardView(game: game)
//                    }
//                }
//                .padding()
            }
            .navigationTitle("Games")
            .frame(maxWidth: .infinity)
            .background(Color.background)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .toolbar {
                addButton
            }
        }
//        .onChange(of: games) { oldGames, newGames in
//            UserDefaults.standard.saveGames(newGames)
//        }
    }
}

#Preview {
    GamesMainScreenView()
}

extension GamesMainScreenView {
    private var addButton: some View {
        NavigationLink(destination: AddGameView(games: $games)) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.highlight, lineWidth: 2)
                    .frame(width: 30, height: 30)
                
                Image(systemName: "plus")
                    .foregroundColor(Color.highlight)
                    .font(.system(size: 20))
            }
        }
    }
}
