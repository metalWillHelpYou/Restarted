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

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.text, forKey: .text)
        try container.encode(self.isRead, forKey: .isRead)
        try container.encode(self.isForBeginers, forKey: .isForBeginers)
        try container.encode(self.readingTime, forKey: .readingTime)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.text = try container.decode(String.self, forKey: .text)
        self.isRead = try container.decodeIfPresent(Bool.self, forKey: .isRead) ?? false
        self.isForBeginers = try container.decodeIfPresent(Bool.self, forKey: .isForBeginers) ?? false
        self.readingTime = try container.decodeIfPresent(Int.self, forKey: .readingTime) ?? 0
    }
}

final class ArticleManager {
    static let shared = ArticleManager()
    private init() { }
    
    private let db = Firestore.firestore()
    var articles: [Article] = []
    private let articleCollection = Firestore.firestore().collection("articles")
    
    func fetchArticles() async -> [Article] {
        let db = Firestore.firestore()
        
        do {
            let snapshot = try await db.collection("articles").getDocuments()
            let articles = try snapshot.documents.map { doc -> Article in
                let jsonData = try JSONSerialization.data(withJSONObject: doc.data())
                return try JSONDecoder().decode(Article.self, from: jsonData)
            }
            return articles
        } catch {
            print("Error loading or parsing articles: \(error)")
            return []
        }
    }
    
    private func articleDocument(articleId: String) -> DocumentReference {
        articleCollection.document(articleId)
    }
    
    func updateReadStatus(articleId: String, isRead: Bool) async throws {
        guard Auth.auth().currentUser?.uid != nil else {
            print("Error: The user is not authenticated.")
            throw URLError(.userAuthenticationRequired)
        }
        
        let data: [String: Any] = [
            Article.CodingKeys.isRead.rawValue: isRead
        ]
        
        do {
            try await articleDocument(articleId: articleId).updateData(data)
        } catch {
            print("Error updating the status of an article: \(error)")
            throw error
        }
    }
}
