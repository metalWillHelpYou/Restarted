//
//  ArticleModel.swift
//  Restarted
//
//  Created by metalWillHelpYou on 03.12.2024.
//

import Foundation
import FirebaseFirestore

struct Article: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let text: String
    var isRead: Bool

    init(
        id: String,
        title: String,
        text: String,
        isRead: Bool = false
    ) {
        self.id = id
        self.title = title
        self.text = text
        self.isRead = isRead
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case text = "text"
        case isRead = "is_read"
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.text, forKey: .text)
        try container.encode(self.isRead, forKey: .isRead)
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.text = try container.decode(String.self, forKey: .text)
        self.isRead = try container.decodeIfPresent(Bool.self, forKey: .isRead) ?? false
    }
}

class FirestoreService {
    private let db = Firestore.firestore()
    var articles: [Article] = []

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
            print("Ошибка загрузки или парсинга статей: \(error)")
            return []
        }
    }
}

