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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    if !viewModel.savedArticles.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Beginner level")
                                .font(.title)
                                .padding(.horizontal)
                                .offset(y: 8)
                            
                            ForEach(viewModel.savedArticles.filter { $0.isForBeginners }) { article in
                                NavigationLink(destination: ArticleView(article: article)) {
                                    ArticleCardView(article: article)
                                        .padding(.bottom)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Intermediate level")
                                .font(.title)
                                .padding(.horizontal)
                                .offset(y: 8)
                            
                            ForEach(viewModel.savedArticles.filter { !$0.isForBeginners }) { article in
                                NavigationLink(destination: ArticleView(article: article)) {
                                    ArticleCardView(article: article)
                                        .padding(.bottom)
                                }
                            }
                        }
                        
                        Spacer()
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
}

#Preview {
    ArticleMainScreenView()
        .environmentObject(ArticleViewModel())
}
