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
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isNotificationsOn, forKey: .isNotificationsOn)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isNotificationsOn = try container.decodeIfPresent(Bool.self, forKey: .isNotificationsOn)
    }
}

final class UserManager {
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    private let articleCollection = Firestore.firestore().collection("articles")

    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
        
        let articlesSnapshot = try await articleCollection.getDocuments()
        
        let userArticlesCollection = userDocument(userId: user.userId).collection("articles")
        
        for document in articlesSnapshot.documents {
            let articleData = document.data()
            try await userArticlesCollection.document(document.documentID).setData(articleData)
        }
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }

    func updateUserNotificationsStatus(userId: String, isNotificationsOn: Bool) async throws {
        let data: [String : Any] = [
            DBUser.CodingKeys.isNotificationsOn.rawValue : isNotificationsOn
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func deleteUserDocument(userId: String) async throws {
        let documentRef = userCollection.document(userId)
        try await documentRef.delete()
        print("User with id \(userId) deleted successfully")
    }
}
