//
//  SignInApple.swift
//  App_GroupChat_IOS
//
//  Created by Tran Phuc Huynh on 2/12/24.
//

import Foundation
import CryptoKit
import AuthenticationServices

struct SignInAppleResult {
    let idToken: String
    let nonce: String
    let fullname: PersonNameComponents?
}

class SignInApple: NSObject {
    
    private var currentNonce: String?
    private var completionHandler: ((Result<SignInAppleResult, AppleSignInError>) -> Void)? = nil
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
    
    func startSignInWithAppleFlow(completion: @escaping (Result<SignInAppleResult, AppleSignInError>) -> Void) {
        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        guard let topVC = UIApplication.getTopViewController() else {
            completion(.failure(.unableToGrabTopVC))
            return
        }
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVC
        authorizationController.performRequests()
    }
}

// Sign In With Apple Helpers
extension SignInApple: ASAuthorizationControllerDelegate, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce, let completionHandler = completionHandler else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken, let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to fetch identity token")
                completionHandler(.failure(.appleIDTokenError))
                return
            }
            
            let appleResult = SignInAppleResult(idToken: idTokenString, nonce: nonce, fullname: appleIDCredential.fullName)
            completionHandler(.success(appleResult))
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
        
    }
}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
