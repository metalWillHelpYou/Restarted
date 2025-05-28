//
//  ArticleView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI
import MarkdownUI

struct ArticleView: View {
    @EnvironmentObject var articleViewModel: ArticleViewModel
    
    let article: Article
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                Markdown(article.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .padding(.horizontal)
            .background(Color.background)
        }
    }
}

#Preview {
    ArticleView(article: Article(
        id: "dsdsd",
        title: "First",
        text: "blabla",
        isForBeginners: true,
        readingTime: 9
    ))
    .environmentObject(ArticleViewModel())
}
