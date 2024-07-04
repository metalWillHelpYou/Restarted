//
//  AddGameView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 27.06.2024.
//

import SwiftUI

struct AddGameView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @Binding var games: [Game]
    @State private var newGameTitle = ""
    @State private var selectedGenre: Genre = .action
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                gameInfo
                
                Spacer()
                
                addGameButton
            }
            .navigationTitle("Add new game")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .background(Color.background)
            .onTapGesture {
                self.hideKeyboard()
            }
        }
    }
    
    var gameInfo: some View {
        VStack {
            TextField("Title", text: $newGameTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top)
            
            HStack {
                Text("Genre:")
                
                Picker("Genre", selection: $selectedGenre) {
                    ForEach(Genre.allCases) { genre in
                        Text(genre.rawValue).tag(genre)
                    }
                }
            }
        }
    }
    
    var addGameButton: some View {
        Button(action: {
            addGame()
            dismiss()
        }) {
            Text("Add Game")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.highlight)
                .foregroundColor(userTheme == .light ? .white : .black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private func addGame() {
        let newGame = Game(title: newGameTitle, genre: selectedGenre)
        games.append(newGame)
        UserDefaults.standard.saveGames(games)
        newGameTitle = ""
        selectedGenre = .action
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var games: [Game] = [
            Game(title: "Sample Game 1", genre: .action),
        ]
        
        var body: some View {
            AddGameView(games: $games)
        }
    }
    
    return PreviewContainer()
}
