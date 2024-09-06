//
//  ArticleCardView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ArticleCardView: View {
    @EnvironmentObject var articleVm: ArticleEntityViewModel
    @AppStorage("background") var background: String?
    var article: Article
    
    @State private var isRead: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(article.isRead ? .highlight: .clear)
                .frame(height: 72)
                .strokeBacground()
            
            HStack {
                Text(article.title ?? "Unknown")
                    .foregroundColor(article.isRead ? .gray : Color.text)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                
                Spacer()
                Text(article.isRead.description)
                
                Button(action: {
                    isRead.toggle()
                    article.isRead = isRead
                    //articleVm.saveData()
                }, label: {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.highlight)
                        .padding()
                })
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}


#Preview {
    let testArticle = Article(context: ArticleEntityViewModel().container.viewContext)
    testArticle.title = "Test Article"
    testArticle.content = "This is a test article for preview purposes."
    testArticle.isRead = false
    
    return ArticleCardView(article: testArticle)
        .environmentObject(ArticleEntityViewModel())
}
