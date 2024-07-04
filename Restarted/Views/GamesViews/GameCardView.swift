//
//  GameCardView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 22.05.2024.
//

import SwiftUI

struct GameCardView: View {
    let game: Game
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.6))
                .frame(height: 72)
                .background(.black)
            
//            Image(game.imageName)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(height: 72)
//                .opacity(0.4)
            
            Text(game.title)
                .foregroundColor(.white)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    GameCardView(game: Game(title: "Title", genre: .action))
}
