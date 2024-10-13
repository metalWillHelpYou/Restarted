//
//  ArticleCardView.swift
//  Restarted
//
//  Created by metalWillHelpYou on 21.05.2024.
//

import SwiftUI

struct ArticleCardView: View {
    @EnvironmentObject var articleVm: ArticleViewModel
    var article: Article

    @AppStorage("isRead_\(UUID().uuidString)") var isRead: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(isRead ? Color.green.opacity(0.3) : Color.clear)
                .frame(height: 72)
                .strokeBackground(Color.highlight)
            
            HStack {
                Text(article.title ?? "Unknown")
                    .foregroundColor(isRead ? .gray : Color.text)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                Text(article.isRead.description)
                
                Button(action: {
                    toggleReadStatus()
                }, label: {
                    Image(systemName: isRead ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundColor(.highlight)
                        .padding()
                })
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
        .padding(.vertical, 4)
        .onDisappear() {
            articleVm.saveData()
        }
        .onAppear {
            self.isRead = article.isRead
        }
    }

    private func toggleReadStatus() {
        let newStatus = !isRead
        print("Changing isRead status from \(isRead) to \(newStatus) for article: \(article.title ?? "Unknown")")
        isRead = newStatus
        articleVm.updateReadStatus(for: article, isRead: newStatus)
    }
}

#Preview {
    let testArticle = Article(context: ArticleViewModel().container.viewContext)
    testArticle.title = "Test Article"
    testArticle.content = "This is a test article for preview purposes."
    testArticle.isRead = false
    
    return ArticleCardView(article: testArticle)
        .environmentObject(ArticleViewModel())
}

