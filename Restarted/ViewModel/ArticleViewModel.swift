//
//  ArticleEntityViewModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 30.08.2024.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class ArticleViewModel: ObservableObject {
    @Published var savedArticles: [Article] = []

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(articlesDidChange), name: .articlesDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .articlesDidChange, object: nil)
    }
    
    @objc private func articlesDidChange() {
        DispatchQueue.main.async {
            self.savedArticles = ArticleManager.shared.articles
        }
    }
    
    func startListening() {
        ArticleManager.shared.startListeningToArticles()
    }
    
    func stopListening() {
        ArticleManager.shared.stopListeningToArticles()
    }

    func toggleReadStatus(for articleId: String) {
        guard let index = savedArticles.firstIndex(where: { $0.id == articleId }) else {
            return
        }
        
        savedArticles[index].isRead.toggle()
        let updatedIsRead = savedArticles[index].isRead
        
        Task {
            do {
                try await ArticleManager.shared.updateReadStatus(
                    articleId: articleId,
                    isRead: updatedIsRead
                )
            } catch {
                DispatchQueue.main.async {
                    self.savedArticles[index].isRead.toggle()
                }
                print("Error updating the reading status: \(error)")
            }
        }
    }
}
