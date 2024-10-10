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
                VStack {
//                    ForEach(articleVm.savedArticles) { article in
//                         NavigationLink(destination: ArticleView(article: article)) {
//                             ArticleCardView(article: article)
//                         }
//                     }
                    Text("Work In progress")
                        .font(.largeTitle)
                }
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Articles")
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .background(Color.background)
        }
    }
}

//TODO: добавить в struct Article проперти для отслеживания прочтения статьи(показывать что статья прочитана)

#Preview {
    ArticleMainScreenView()
        .environmentObject(ArticleViewModel())
}
