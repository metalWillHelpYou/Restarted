//
//  ArticleMainScreenView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct ArticleMainScreenView: View {
    @StateObject private var viewModel = ArticleEntityViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.savedArticles) { article in
                VStack(alignment: .leading) {
                    Text(article.title ?? "Untitled")
                        .font(.headline)
                    Text(article.content ?? "No content")
                        .font(.subheadline)
                    if article.isRead {
                        Text("Read")
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
                .onTapGesture {
                    viewModel.markArticleAsRead(article)
                }
            }
            .navigationTitle("Articles")
        }
    }
}

#Preview {
    ArticleMainScreenView()
        .environmentObject(ArticleEntityViewModel())
}

//TODO: добавить в struct Article проперти для отслеживания прочтения статьи(показывать что статья прочитана)

//extension ArticleMainScreenView {
//    @ViewBuilder
//    private func articleSection(title: String, articles: [Article]) -> some View {
//        Text(title)
//            .font(.title)
//            .frame(maxWidth: .infinity, alignment: .leading)
//
//        ForEach(articles) { article in
//            NavigationLink(destination: ArticleView(article: article)) {
//                ArticleCardView(article: article)
//            }
//        }
//    }
//}
