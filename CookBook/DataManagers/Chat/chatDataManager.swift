//
//  chatDataManager.swift
//  CookBook
//
//  Created by Sean Gwee on 4/7/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class chatDataManager: NSObject {
    
    static let db = Firestore.firestore()
    
    static func loadChat(onComplete: (([Friend]) -> Void)?){
        db.collection("friends").getDocuments()
            {
                (querySnapshot, err) in var friendsList : [Friend] = []
                
                if let err = err{
                    print("Error getting documents: \(err)")
                }
                else{
                    for document in querySnapshot!.documents
                    {
                        var friend = try? document.data(as: Friend.self) as! Friend
                        if friend != nil{
                            friendsList.append(friend!)
                        }
                    }
                }
                onComplete?(friendsList)
        }
    }
    
    static func insertOrReplaceChat(_ friend: Friend) {
        try? db.collection("friends") .document(friend.friendId)
            .setData(from: friend, encoder: Firestore.Encoder()) {
                err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully added!")
                }
        }
    }
    
    static func deleteFriend(_ friend: Friend)
    {
        
        db.collection("friends").document(friend.friendId).delete() {
            err in
            
            if let err = err {
                
                print("Error removing document: \(err)")
            } else {
                
                print("Document successfully removed!")
            }
            
        }
    }
    
}
