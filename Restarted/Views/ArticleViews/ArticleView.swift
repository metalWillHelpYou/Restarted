//
//  ArticleView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ArticleView: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .multilineTextAlignment(.leading)
                .bold()
                .font(.title)
            
            Image(article.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 368, height: 228)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: .black.opacity(0.4), radius: 4, y: 4)
            
            Text(article.content)
            
            Spacer()
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    ArticleView(article: Article(title: "What is\nvideo game addiction?", content:"Video game addiction is a behavioral disorder characterized by excessive and com", imageName: "1st"))
}

//TODO: показать сколько времени потребуется для прочтения
//FIXME: починить рамку картинки и всего View в целом
