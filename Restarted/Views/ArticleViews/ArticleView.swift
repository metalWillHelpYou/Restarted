//
//  ArticleView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ArticleView: View {
    @EnvironmentObject var articleVm: ArticleEntityViewModel
    var article: Article?
    
    @State private var isComplete = false
    @State private var isRead = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article?.title ?? "Unknown")
                .multilineTextAlignment(.leading)
                .bold()
                .font(.title)
            
//            Image(article.imageName)
//                .resizable()
//                .frame(height: 228)
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//                .shadow(color: .black.opacity(0.4), radius: 4, y: 4)
            
            Text(article?.content ?? "Unknown")
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(32)
        .background(Color.background)
    }
}

//TODO: показать сколько времени потребуется для прочтения

#Preview {
    ArticleView(article: nil)
        .environmentObject(ArticleEntityViewModel())
}
