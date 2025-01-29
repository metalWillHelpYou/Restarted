//
//  ArticleView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ArticleView: View {
    @EnvironmentObject var articleViewModel: ArticleViewModel
    
    let article: Article
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Reading time: \(article.readingTime) minutes")
                
                Text(article.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .navigationTitle(article.title)
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, alignment: .leading)
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
