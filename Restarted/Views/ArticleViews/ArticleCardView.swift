//
//  ArticleCardView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ArticleCardView: View {
    let article: Article
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.6))
                .frame(height: 72)
                .background(.black)
            
            Image(article.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .opacity(0.4)
            
            Text(article.title)
                .foregroundColor(.white)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.vertical, 8)
    }
}

#Preview {
    ArticleCardView(article: Article(title: "Title", content: "Content", imageName: "1st"))
}
