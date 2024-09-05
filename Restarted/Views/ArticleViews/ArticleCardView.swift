//
//  ArticleCardView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ArticleCardView: View {
    var article: Article?
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.clear)
                .frame(height: 72)
                .strokeBacground()
            
            HStack {
                if let isRead = article?.isRead, isRead {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .padding(.leading, 16)
                }
                
                Text(article?.title ?? "Unknown")
                    .foregroundColor(article?.isRead == true ? .gray : Color.text)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}


#Preview {
    ArticleCardView()
        .environmentObject(ArticleEntityViewModel())
}
