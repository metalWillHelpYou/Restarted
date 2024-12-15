//
//  ArticleView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ArticleView: View {
    @EnvironmentObject var articleVm: ArticleViewModel
    
    let article: Article
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Reading time: \(article.readingTime) minutes")
                
    //            Image(article.imageName)
    //                .resizable()
    //                .frame(height: 228)
    //                .clipShape(RoundedRectangle(cornerRadius: 15))
    //                .shadow(color: .black.opacity(0.4), radius: 4, y: 4)
                
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

//TODO: показать сколько времени потребуется для прочтения

#Preview {
    ArticleView(article: Article(id: "dsdsd", title: "First", text: "blabla", isForBeginers: true, readingTime: 9))
        .environmentObject(ArticleViewModel())
}
