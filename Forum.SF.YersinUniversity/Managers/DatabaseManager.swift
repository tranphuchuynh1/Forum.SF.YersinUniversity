//
//  DatabaseManager.swift
//  App_GroupChat_IOS
//
//  Created by Tran Phuc Huynh on 27/11/24.
//
import Combine
import FirebaseFirestore

enum FetchMessagesError: Error {
    case snapshotError
}

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let messageRef = Firestore.firestore().collection("messages")
    
    var messagesPublisher = PassthroughSubject<[Message], Error>()
    
    func fetchMessages(completion: @escaping (Result<[Message], FetchMessagesError>) -> Void) {
        messageRef.order(by: "createAt", descending: true).limit(to: 25).getDocuments { [weak self] snapshot, error in
            guard let snapshot = snapshot, let strongSelf = self, error == nil else {
                completion(.failure(.snapshotError))
                return
            }
            
            strongSelf.listenForNewMessageInDatabase()
            let messages = strongSelf.createMessagesFromFirebaseSnapshot(snapshot: snapshot)
            completion(.success(messages))
        }
    }
    
    func sendMessageToDatabase(message: Message, completion: @escaping (Bool) -> Void) {
        let data = [
            "text": message.text,
            "userUid": message.userUid,
            "photoURL": message.photoURL,
            "createAt": Timestamp(date: message.createdAt)
        ] as [String : Any]
        messageRef.addDocument(data: data) { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    func listenForNewMessageInDatabase() {
        messageRef.order(by: "createAt", descending: true).limit(to: 25).addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot, let strongSelf = self, error == nil else {
                return
            }
            let messgaes = strongSelf.createMessagesFromFirebaseSnapshot(snapshot: snapshot)
            strongSelf.messagesPublisher.send(messgaes)
        }
        
    }
    
    func createMessagesFromFirebaseSnapshot(snapshot: QuerySnapshot) -> [Message] {
        let docs = snapshot.documents
        
        var messages = [Message]()
        for doc in docs {
            let data = doc.data()
            let text = data["text"] as? String ?? "Error"
            let userUid = data["userUid"] as? String ?? "Error"
            let photoURL = data["photoURL"] as? String
            let createAt = data["createAt"] as? Timestamp ?? Timestamp()
            
            let msg = Message(userUid: userUid, text: text, photoURL: photoURL, createdAt: createAt.dateValue())
            messages.append(msg)
        }
        return messages.reversed()
    }
}
