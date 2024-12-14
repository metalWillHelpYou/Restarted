//
//  ArticleMainScreenView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct ArticleMainScreenView: View {
    @EnvironmentObject var articleVm: ArticleViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if !articleVm.savedArticles.isEmpty {
                        ForEach(articleVm.savedArticles) { article in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(article.title)
                                    .font(.headline)
                                Text(article.text.isEmpty ? "Нет текста" : article.text)
                                    .lineLimit(2)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(article.isRead ? "Прочитано" : "Не прочитано")
                                    .font(.caption)
                                    .foregroundColor(article.isRead ? .green : .red)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                    } else {
                        Text("No Articles Yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Articles")
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .background(Color.background)
            .task {
                await articleVm.fetchArticles()
            }
        }
    }
}



//TODO: добавить в struct Article проперти для отслеживания прочтения статьи(показывать что статья прочитана)

#Preview {
    ArticleMainScreenView()
        .environmentObject(ArticleViewModel())
}
