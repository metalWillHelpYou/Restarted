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
            Spacer()
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
            
            iReadThisButton
        }
        .padding()
        .background(Color.background)
    }
}

//TODO: показать сколько времени потребуется для прочтения
extension ArticleView {
    private var iReadThisButton: some View {
        ZStack {
            Rectangle()
                .fill(Color.highlight)
                .frame(height: 55)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack {
                Image(systemName: isRead ? "checkmark.circle" : "circle")
                
                Text("I read this")
                    .font(.title2)
                    .frame(height: 56)
                    .cornerRadius(15)
            }
        }
        .font(.title3)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onTapGesture {
            //withAnimation(.spring()) {
                isRead.toggle()
                if isRead {
                    HapticManager.instance.notification(type: .success)
                } else {
                    HapticManager.instance.notification(type: .warning)
                }
                if let article = article {
                    articleVm.updateReadStatus(for: article, isRead: isRead)
                }
           // }
        }
        .onAppear {
            isRead = ((article?.isRead) != nil)
        }
    }
}

#Preview {
    ArticleView(article: nil)
        .environmentObject(ArticleEntityViewModel())
}
