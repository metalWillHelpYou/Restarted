//
//  ArticleMainScreenView.swift
//  Restarted
//
//  Created by metalwillhelpyou on 02.04.2024.
//

import SwiftUI

struct ArticleMainScreenView: View {
    @EnvironmentObject var viewModel: ArticleViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if !viewModel.savedArticles.isEmpty {
                        articleSection(title: "Beginner level", filter: { $0.isForBeginners })
                        articleSection(title: "Intermediate level", filter: { !$0.isForBeginners })
                    } else {
                        ProgressView()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Articles")
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .background(Color.background)
            .onAppear { viewModel.startObserving() }
            .onDisappear { viewModel.stopObserving() }
        }
    }
    
    private func articleSection(title: String, filter: (Article) -> Bool) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .padding(.horizontal)
                .offset(y: 8)
            
            ForEach(viewModel.savedArticles.filter(filter)) { article in
                NavigationLink(destination: ArticleView(article: article)) {
                    ArticleCardView(article: article)
                        .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    ArticleMainScreenView()
        .environmentObject(ArticleViewModel())
}
