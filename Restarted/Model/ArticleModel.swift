//
//  ArticleModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 03.12.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Article: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let text: String
    var isRead: Bool
    let isForBeginers: Bool
    let readingTime: Int

    init(
        id: String,
        title: String,
        text: String,
        isRead: Bool = false,
        isForBeginers: Bool,
        readingTime: Int
    ) {
        self.id = id
        self.title = title
        self.text = text
        self.isRead = isRead
        self.isForBeginers = isForBeginers
        self.readingTime = readingTime
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case text = "text"
        case isRead = "is_read"
        case isForBeginers = "is_for_beginers"
        case readingTime = "reading_time"
    }
}

final class ArticleManager: ObservableObject {
    static let shared = ArticleManager()
    @Published var articles: [Article] = []
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    private init() { }

    private func userArticlesCollection() -> CollectionReference? {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: The user is not authenticated.")
            return nil
        }
        return db.collection("users").document(userId).collection("articles")
    }
    
    func startListeningToArticles() {
        guard let articlesCollection = userArticlesCollection() else {
            print("Error: User is not authenticated or collection is unavailable.")
            return
        }
        
        listener = articlesCollection.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error listening to article changes: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents in articles collection.")
                self?.articles = []
                return
            }
            
            do {
                self?.articles = try documents.map { doc -> Article in
                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data())
                    return try JSONDecoder().decode(Article.self, from: jsonData)
                }
            } catch {
                print("Error decoding articles: \(error.localizedDescription)")
                self?.articles = []
            }
        }
    }
    
    func stopListeningToArticles() {
        listener?.remove()
        listener = nil
    }
    
    func updateReadStatus(articleId: String, isRead: Bool) async throws {
        guard let document = articleDocument(articleId: articleId) else {
            print("Error: Unable to get reference to user article document.")
            throw URLError(.badURL)
        }
        
        let data: [String: Any] = [
            Article.CodingKeys.isRead.rawValue: isRead
        ]
        
        do {
            try await document.updateData(data)
        } catch {
            print("Error updating the status of an article: \(error)")
            throw error
        }
    }
    
    private func articleDocument(articleId: String) -> DocumentReference? {
        guard let articlesCollection = userArticlesCollection() else { return nil }
        return articlesCollection.document(articleId)
    }
}

