//
//  ArticleView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ArticleView: View {
    @EnvironmentObject var vm: ArticleEntityViewModel
    //let article: Article
    
    @State private var isComplete = false
    @State private var isRead = false
    
    var body: some View {
        VStack(alignment: .leading) {
//            Text(article.title)
//                .multilineTextAlignment(.leading)
//                .bold()
//                .font(.title)
//            
//            Image(article.imageName)
//                .resizable()
//                .frame(height: 228)
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//                .shadow(color: .black.opacity(0.4), radius: 4, y: 4)
//            
//            Text(article.content)
//            
//            Spacer()
            
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
                .fill(isRead ? Color.green : .mint)
                .frame(maxWidth: isComplete ? .infinity : 0)
                .frame(height: 55)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.gray)
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
        .frame(maxWidth: .infinity)
        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 50) { (isPressing) in
            if isPressing {
                withAnimation(.easeInOut(duration: 1)) {
                    isComplete = true
                }
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if !isRead {
                        withAnimation(.easeInOut) {
                            isComplete = false
                        }
                    }
                }
            }
        } perform: {
            withAnimation(.easeInOut) {
                isRead.toggle()
                if isRead {
                    HapticManager.instance.notification(type: .success)
                } else {
                    HapticManager.instance.notification(type: .warning)
                }
            }
        }
    }
}

#Preview {
    ArticleView()
        .environmentObject(ArticleEntityViewModel())
}
