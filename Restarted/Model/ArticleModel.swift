//
//  ArticleModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 03.12.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// Represents a single article and its metadata
struct Article: Codable, Identifiable {
    let id: String
    let title: String
    let text: String
    var isRead: Bool
    let isForBeginners: Bool
    let readingTime: Int

    // Designated initializer for full control
    init(
        id: String,
        title: String,
        text: String,
        isRead: Bool = false,
        isForBeginners: Bool,
        readingTime: Int
    ) {
        self.id = id
        self.title = title
        self.text = text
        self.isRead = isRead
        self.isForBeginners = isForBeginners
        self.readingTime = readingTime
    }

    // Maps Swift properties to Firestore field names
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case text
        case isRead = "is_read"
        case isForBeginners = "is_for_beginners"
        case readingTime = "reading_time"
    }
}

// Provides real-time sync and CRUD operations for the user's articles
final class ArticleManager: ObservableObject {
    // Singleton instance
    static let shared = ArticleManager()

    // Reactive cache powering the UI
    @Published var articles: [Article] = []
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    private init() { }

    // Firestore path helpers
    private func userArticlesCollection() -> CollectionReference? {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: The user is not authenticated.")
            return nil
        }
        return db.collection("users").document(userId).collection("articles")
    }

    // Real-time observation
    func startObservingArticles() {
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

    // Stops listening for article changes
    func stopObservingArticles() {
        listener?.remove()
        listener = nil
    }

    // Sets the `isRead` flag for a given article
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

    // Returns a reference to a single article document
    private func articleDocument(articleId: String) -> DocumentReference? {
        guard let articlesCollection = userArticlesCollection() else { return nil }
        return articlesCollection.document(articleId)
    }
}
