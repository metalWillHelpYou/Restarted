//
//  ArticleMainScreenView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct ArticleMainScreenView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @StateObject private var loadFromJSON = DataLoaderFromJSON<Article>(filename: "articles")

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack(spacing: 2) {
                        Text("Beginner:")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(loadFromJSON.items) { article in
                            NavigationLink(destination: ArticleView(article: article)) {
                                ArticleCardView(article: article)
                            }
                        }
                    }
                    
                    VStack(spacing: 2) {
                        Text("Intermediate:")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 18)
            .navigationTitle("Articles")
            .background(Color.background)
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
        }
        .preferredColorScheme(userTheme.colorTheme)
    }
}

#Preview {
    ArticleMainScreenView()
}

//TODO: добавить в struct Article проперти для отслеживания уровня статьи => парсить статьи на разные уровни

//TODO: добавить в struct Article проперти для отслеживания прочтения статьи(показывать что статья прочитана)
