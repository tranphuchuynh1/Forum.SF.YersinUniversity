//  AuthManager.swift
//  App_GroupChat_IOS
//
//  Created by Tran Phuc Huynh on 27/11/24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import CryptoKit

struct ChatRoomUser {
    let uid: String
    let name: String
    let email: String?
    let photoURL: String?
}

enum GoogleSignInError: Error {
    case unableToGrabTopVC
    case signInPresentationError
    case authSignInError
}

enum AppleSignInError: Error {
    case authSignInError
    case unableToGrabTopVC
    case appleIDTokenError
}

final class AuthManager: NSObject {
    
    static let shared = AuthManager()
    
    let auth = Auth.auth()
    
    // Sign In With Apple nonce
    let signInApple = SignInApple()
    
    func getCurrentUser() -> ChatRoomUser? {
        guard let authUser = auth.currentUser else {
            return nil
        }
        return ChatRoomUser(uid: authUser.uid, name: authUser.displayName ?? "Unknown", email: authUser.email, photoURL: authUser.photoURL?.absoluteString)
    }
    
    func signInWithApple(completion: @escaping (Result<ChatRoomUser, AppleSignInError>) -> Void) {
        signInApple.startSignInWithAppleFlow { [weak self] result  in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let appleResult):
                let credential = OAuthProvider.appleCredential(withIDToken: appleResult.idToken, rawNonce: appleResult.nonce, fullName: appleResult.fullname)
                // sign in with Firebase
                strongSelf.auth.signIn(with: credential) { (authResult, error) in
                    guard let authResult = authResult, error == nil else {
                        completion(.failure(.authSignInError))
                        return
                    }
                    let user = ChatRoomUser(uid: authResult.user.uid, name: authResult.user.displayName ?? "Unknown", email: authResult.user.email, photoURL: authResult.user.photoURL?.absoluteString)
                    completion(.success(user))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signInWithGoogle(completion: @escaping (Result<ChatRoomUser, GoogleSignInError>) -> Void) {
        let clientID = "752936963083-4ihjhmtpp7uscos5pkuhf041tt9a382t.apps.googleusercontent.com"
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let topVC = UIApplication.getTopViewController() else {
            completion(.failure(.unableToGrabTopVC))
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { [unowned self] result, error in
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString,
                  error == nil else {
                completion(.failure(.signInPresentationError))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            auth.signIn(with: credential) { result, error in
                guard let result = result, error == nil else {
                    completion(.failure(.authSignInError))
                    return
                }
                let user = ChatRoomUser(uid: result.user.uid, name: result.user.displayName ?? "Unknown", email: result.user.email, photoURL: result.user.photoURL?.absoluteString)
                completion(.success(user))
            }
        }
    }
    
    func signOut() throws {
        try auth.signOut()
    }
}
