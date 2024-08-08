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
    @State private var showAddGameView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
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
                        Button(action: {
                            showAddGameView.toggle()
                        }, label: {
                            HStack {
                                Text("Add your first game ->")
                                    .padding(.horizontal, 2)
                                
                                addGameButton
                            }
                        })
                    }
                }
            }
            .navigationTitle("Games")
            .frame(maxWidth: .infinity)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .toolbar {
                if !vm.savedEntities.isEmpty {
                    addGameButton
                }
            }
            .popover(isPresented: $showAddGameView, content: {
                AddGameView(vm: vm, gameTitle: $gameTitle)
                    .presentationCompactAdaptation(.sheet)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            })
        }
    }
}

#Preview {
    GamesMainScreenView()
}

extension GamesMainScreenView {
    private var addGameButton: some View {
        Button(action: {
            showAddGameView.toggle()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.highlight, lineWidth: 2)
                    .frame(width: 30, height: 30)
                
                Image(systemName: "plus")
                    .foregroundColor(Color.highlight)
                    .font(.system(size: 20))
            }
        })
    }
}
