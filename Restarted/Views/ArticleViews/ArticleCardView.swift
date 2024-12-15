//
//  ArticleCardView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ArticleCardView: View {
    @EnvironmentObject var articleVm: ArticleViewModel
    let article: Article
    
    var body: some View {
        HStack {
            Text(article.title)
                .foregroundColor(Color.text)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                .padding(.vertical, 26)
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    articleVm.toggleReadStatus(for: article.id)
                }
            }, label: {
                Image(systemName: article.isRead ? "checkmark.circle" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.highlight)
                    .padding()
            })
        }
        .background(article.isRead ? Color.green.opacity(0.3) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .strokeBackground(Color.highlight)
        .padding(.horizontal)
    }
}

#Preview {
    ArticleCardView(article: Article(id: "id", title: "Title", text: "Text", isForBeginers: true, readingTime: 7))
        .environmentObject(ArticleViewModel())
}
