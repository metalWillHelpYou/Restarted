//
//  GamesMainScreenView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 20.05.2024.
//

import SwiftUI

struct GamesMainScreenView: View {
    @StateObject var vm = GameEntityViewModel()
    @State private var gameTitle: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if !vm.savedEntities.isEmpty {
                    List {
                        ForEach(vm.savedEntities) { game in
                            Text(game.title ?? "")
                        }
                        .onDelete(perform: vm.deleteGame)
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Text("Click Plus button")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Games")
            .frame(maxWidth: .infinity)
            .background(Color.background)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .toolbar {
                addButton
            }
        }
    }
}

#Preview {
    GamesMainScreenView()
}

extension GamesMainScreenView {
    private var addButton: some View {
        NavigationLink(destination: AddGameView(vm: vm, gameTitle: $gameTitle)) {
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
