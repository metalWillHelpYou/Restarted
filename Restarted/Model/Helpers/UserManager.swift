//
//  UserManager.swift
//  Restarted
//
//  Created by metalWillHelpYou on 11.11.2024.
//

import Foundation
import FirebaseFirestore

struct DBUser {
    let userId: String
    let email: String?
    let photoURL: String?
    let dateCreated: Date?
}

final class UserManager {
    static let shared = UserManager()
    private init() { }
    
    func createUser(auth: AuthDataResultModel) async throws {
        var userData: [String : Any] = [
            "user_id" : auth.uid,
            "date_created" : Timestamp(),
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        if let photoUrl = auth.photoUrl {
            userData["photo_url"] = photoUrl
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String
        let photoURL = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date
        
        return DBUser(userId: userId, email: email, photoURL: photoURL, dateCreated: dateCreated)
    }
}
