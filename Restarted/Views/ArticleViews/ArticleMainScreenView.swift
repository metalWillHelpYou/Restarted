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
                beginnerSection
                intermediateSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .navigationTitle("Articles")
            .background(Color.background)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
        }
    }
    
    var beginnerSection: some View {
        VStack(spacing: 2) {
            Text("Beginner:")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(ArticleData.beginnerArticles) { article in
                NavigationLink(destination: ArticleView(article: article)) {
                    ArticleCardView(article: article)
                }
            }
        }
    }
    
    var intermediateSection: some View {
        VStack(spacing: 2) {
            Text("Intermediate:")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(ArticleData.intermediateArticles) { article in
                NavigationLink(destination: ArticleView(article: article)) {
                    ArticleCardView(article: article)
                }
            }
        }
    }
}

#Preview {
    ArticleMainScreenView()
}

//TODO: добавить в struct Article проперти для отслеживания прочтения статьи(показывать что статья прочитана)
