//
//  ArticleCardView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ArticleCardView: View {
    //let article: Article
    
    var body: some View {
        ZStack(alignment: .leading) {
//            RoundedRectangle(cornerRadius: 15)
//                .fill(.clear)
//                .frame(height: 72)
//                .strokeBacground()
//            
//            Text(article.title)
//                .foregroundColor(Color.text)
//                .font(.body)
//                .multilineTextAlignment(.leading)
//                .padding(.horizontal, 16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.vertical, 8)
    }
}

#Preview {
    ArticleCardView()
        .environmentObject(ArticleEntityViewModel())
}
