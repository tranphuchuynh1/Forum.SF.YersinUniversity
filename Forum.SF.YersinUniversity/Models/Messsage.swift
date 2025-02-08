//
//  Messsage.swift
//  App_GroupChat_IOS
//
//  Created by Tran Phuc Huynh on 24/11/24.
//

import Foundation

struct Message: Decodable, Identifiable, Equatable, Hashable
{
    enum MesssageError {
        case noPhotoURL
    }
    
    let id = UUID()
    let userUid: String
    let text: String
    let photoURL: String?
    let createdAt: Date
    
    func isFromCurrentUser() -> Bool{
        guard let currUser = AuthManager.shared.getCurrentUser() else {
            return false
        }
        
        if currUser.uid == userUid {
            return true
        } else {
            return false
        }
        
    }
    
    func fetchPhotoURL() -> URL? {
        guard let photoURLString = photoURL, let url = URL(string: photoURLString) else {
            return nil
        }
        
        return url
    }
}
