//
//  AuthService.swift
//  InstagramClone
//
//  Created by A1398 on 26/07/2024.
//

import UIKit
import Firebase
import AVFoundation
import FirebaseAuth

// Modele powinny być w osobnych plikach
struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

enum VoidResult {
    case success
    case failure
}


// Takie statyczne serwisy są w ogóle nietestowalne. Dlatego powinno się użyć instancji i DependencyContainer
struct AuthService {
    static func signOut(completion: @escaping ((VoidResult) -> Void)) {
        do {
            try Auth.auth().signOut()
            completion (.success)
        } catch {
            completion (.failure)
        }
    }
    
    static func getUid() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    static func getCurrentUser() -> FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
  
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping(Error?) -> Void) {
        ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("DEBUG: Failed to register user \(error.localizedDescription)")
                    return
                }
                guard let uid = result?.user.uid else { return }
                let data: [String: Any] = ["email": credentials.email,
                                           "fullname": credentials.fullname,
                                           "profileImageUrl": imageUrl,
                                           "uid": uid,
                                           "username": credentials.username]
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
    
    static func resetPassword(widthEmail email: String, completion: SendPasswordResetCallback?) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
}
