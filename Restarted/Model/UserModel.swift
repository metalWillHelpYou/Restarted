//
//  UserManager.swift
//  Restarted
//
//  Created by metalWillHelpYou on 11.11.2024.
//

import Foundation
import FirebaseFirestore

struct DBUser: Codable, Equatable {
    let userId: String
    let email: String?
    let name: String?
    let photoUrl: String?
    let dateCreated: Date?
    var isNotificationsOn: Bool?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.name = auth.name
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isNotificationsOn = false
    }
    
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
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case name = "name"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isNotificationsOn = "is_notifications_on"
    }
}

final class UserManager {
    // MARK: - Singleton
    static let shared = UserManager()
    private init() { }
    
    // MARK: - Firestore Collections
    private let userCollection = Firestore.firestore().collection("users")
    private let articleCollection = Firestore.firestore().collection("articles")
    private let gamesCollection = Firestore.firestore().collection("games")
    
    // MARK: - Private Helpers
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func userArticlesCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("articles")
    }
    
    private func userGamesCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("games")
    }
    
    // MARK: - Public Methods
    
    // Creates a new user in Firestore and initializes their articles collection.
    func createUser(user: DBUser) async throws {
        do {
            try userDocument(userId: user.userId).setData(from: user, merge: false)
            
            try await initializeUserArticles(for: user.userId)
        } catch {
            print("Error with user creation: \(error)")
        }
    }
    
    // Fetches a user document from Firestore.
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    // Updates the user's notifications status in Firestore.
    func updateUserNotificationsStatus(userId: String, isNotificationsOn: Bool) async throws {
        try await updateUserField(
            userId: userId,
            field: DBUser.CodingKeys.isNotificationsOn.rawValue,
            value: isNotificationsOn
        )
    }
    
    // Updates the user's name in Firestore.
    func updateUserName(userId: String, name: String) async throws {
        try await updateUserField(
            userId: userId,
            field: DBUser.CodingKeys.name.rawValue,
            value: name
        )
    }
    
    // Deletes the user's Firestore document.
    func deleteUserDocument(userId: String) async throws {
        try await userDocument(userId: userId).delete()
        print("User with ID \(userId) deleted successfully.")
    }
    
    // MARK: - Private Methods
    
    // Sub collection initialization
    func initializeUserArticles(for userId: String) async throws {
        let articlesSnapshot = try await articleCollection.getDocuments()
        let userArticlesRef = userArticlesCollection(userId: userId)
        
        for document in articlesSnapshot.documents {
            let articleData = document.data()
            try await userArticlesRef.document(document.documentID).setData(articleData)
        }
    }
    
    private func initializeUserGames(for userId: String) async throws {
        let gamesSnapshot = try await gamesCollection.getDocuments()
        let userGamesRef = userGamesCollection(userId: userId)
        
        for document in gamesSnapshot.documents {
            let gameData = document.data()
            try await userGamesRef.document(document.documentID).setData(gameData)
        }
    }

    // Updates a specific field in the user's Firestore document.
    private func updateUserField(userId: String, field: String, value: Any) async throws {
        let data: [String: Any] = [field: value]
        try await userDocument(userId: userId).updateData(data)
    }
}
