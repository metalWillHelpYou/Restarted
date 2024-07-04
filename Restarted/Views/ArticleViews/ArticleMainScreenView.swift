//
//  ArticleMainScreenView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct ArticleMainScreenView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 2){
                    articleSection(title: "Beginner",
                                   articles: ArticleData.articles.filter { $0.level == .beginner })
                    
                    articleSection(title: "Intermediate",
                                   articles: ArticleData.articles.filter { $0.level == .intermediate })
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .navigationTitle("Articles")
            .background(Color.background)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
        }
    }
    
    @ViewBuilder
    private func articleSection(title: String, articles: [Article]) -> some View {
        Text(title)
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        ForEach(articles) { article in
            NavigationLink(destination: ArticleView(article: article)) {
                ArticleCardView(article: article)
            }
        }
    }
}

#Preview {
    ArticleMainScreenView()
}

//TODO: добавить в struct Article проперти для отслеживания прочтения статьи(показывать что статья прочитана)
