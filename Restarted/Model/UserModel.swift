//
//  UserManager.swift
//  Restarted
//
//  Created by metalWillHelpYou on 11.11.2024.
//

import Foundation
import FirebaseFirestore

// Firestore representation of an application user
struct DBUser: Codable, Equatable {
    let userId: String
    let email: String?
    let name: String?
    let photoUrl: String?
    let dateCreated: Date?
    var isNotificationsOn: Bool?
    
    // Convenience initializer built from Firebase auth response
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.name = auth.name
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isNotificationsOn = false
    }
    
    // Designated initializer for full control
    init (
        userId: String,
        email: String? = nil,
        name: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        isNotificationsOn: Bool? = nil
    ) {
        self.userId = userId
        self.email = email
        self.name = name
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isNotificationsOn = isNotificationsOn
    }
    
    // Maps Swift properties to Firestore field names
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case name
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isNotificationsOn = "is_notifications_on"
    }
}

// Handles all Firestore interactions related to the current user
final class UserManager {
    // Singleton instance
    static let shared = UserManager()
    private init() { }
    
    // Firestore collection references
    private let userCollection = Firestore.firestore().collection("users")
    private let articleCollection = Firestore.firestore().collection("articles")
    private let gamesCollection = Firestore.firestore().collection("games")
    
    // Document & sub‑collection helpers
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }

    private func userArticlesCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("articles")
    }
    
    private func userGamesCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("games")
    }
    
    // Creates a new user document and seeds starter articles
    func createUser(user: DBUser) async throws {
        do {
            try userDocument(userId: user.userId).setData(from: user, merge: false)
            try await initializeUserArticles(for: user.userId)
        } catch {
            print("Error with user creation: \(error)")
        }
    }
    
    // Fetches a user snapshot and decodes it into `DBUser`
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    // Toggles notification preference
    func updateUserNotificationsStatus(userId: String, isNotificationsOn: Bool) async throws {
        try await updateUserField(
            userId: userId,
            field: DBUser.CodingKeys.isNotificationsOn.rawValue,
            value: isNotificationsOn
        )
    }
    
    // Updates the user's display name
    func updateUserName(userId: String, name: String) async throws {
        try await updateUserField(
            userId: userId,
            field: DBUser.CodingKeys.name.rawValue,
            value: name
        )
    }
    
    // Permanently deletes user
    func deleteUserDocument(userId: String) async throws {
        try await userDocument(userId: userId).delete()
        print("User with ID \(userId) deleted successfully.")
    }
    
    // Copies default articles into the user's sub‑collection
    func initializeUserArticles(for userId: String) async throws {
        let articlesSnapshot = try await articleCollection.getDocuments()
        let userArticlesRef = userArticlesCollection(userId: userId)
        
        for document in articlesSnapshot.documents {
            let articleData = document.data()
            try await userArticlesRef.document(document.documentID).setData(articleData)
        }
    }
    
    // Copies default games into the user's sub‑collection
    private func initializeUserGames(for userId: String) async throws {
        let gamesSnapshot = try await gamesCollection.getDocuments()
        let userGamesRef = userGamesCollection(userId: userId)
        
        for document in gamesSnapshot.documents {
            let gameData = document.data()
            try await userGamesRef.document(document.documentID).setData(gameData)
        }
    }
    
    // Updates a single field on the user document
    private func updateUserField(userId: String, field: String, value: Any) async throws {
        let data: [String: Any] = [field: value]
        try await userDocument(userId: userId).updateData(data)
    }
}
