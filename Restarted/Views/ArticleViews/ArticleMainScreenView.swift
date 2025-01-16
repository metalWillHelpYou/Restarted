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
                        beginnerSection
                        
                        intermediateSection
                    } else {
                        ProgressView()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Articles")
            .toolbarBackground(Color.highlight.opacity(0.3), for: .navigationBar)
            .background(Color.background)
            .onAppear {
                viewModel.startListening()
            }
            .onDisappear {
                viewModel.stopListening()
            }
        }
    }
}

//TODO: добавить в struct Article проперти для отслеживания прочтения статьи(показывать что статья прочитана)

#Preview {
    ArticleMainScreenView()
        .environmentObject(ArticleViewModel())
}

extension ArticleMainScreenView {
    private var beginnerSection: some View {
        VStack(alignment: .leading) {
            Text("Beginer level")
                .font(.title)
                .padding(.horizontal)
                .offset(y: 8)
            
            ForEach(viewModel.savedArticles) { article in
                if article.isForBeginers {
                    NavigationLink(destination: ArticleView(article: article)) {
                        ArticleCardView(article: article)
                            .padding(.bottom)
                    }
                }
            }
        }
    }
    
    private var intermediateSection: some View {
        VStack(alignment: .leading) {
            Text("Intermediate level")
                .font(.title)
                .padding(.horizontal)
                .offset(y: 8)
            
            ForEach(viewModel.savedArticles) { article in
                if !article.isForBeginers {
                    NavigationLink(destination: ArticleView(article: article)) {
                        ArticleCardView(article: article)
                            .padding(.bottom)
                    }
                }
            }
        }
    }
}
