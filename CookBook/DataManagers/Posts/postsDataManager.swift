//
//  DataManager.swift
//  SDDPProject
//
//  Created by M07-3 on 6/18/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class postsDataManager: NSObject {
    
    static let db = Firestore.firestore()
    
    static func loadPosts(onComplete: (([Posts]) -> Void)?){
        db.collection("posts").getDocuments(){
            
            (querySnapshot, err) in
            var postList : [Posts] = []
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var post = try? document.data(as: Posts.self) as! Posts
                    
                    if post != nil{
                        postList.append(post!)
                    }
                }
            }
            onComplete?(postList)
        }
    }
    
    static func storePostID(_ ID: String) -> String {
        var selectedPost =
            try? db.collection("posts")
                .document(ID)
        var selectedID = selectedPost?.documentID
        
        return selectedID!
    }
    
    static func insertPost(_ post: Posts, onComplete: ((String)-> Void)?){
        var addedDocument = try? db.collection("posts").addDocument(from: post, encoder: Firestore.Encoder())
        
        post.postId = String(addedDocument?.documentID ?? "")

        try? db.collection("posts")
            .document(String(post.postId))
            .setData(from: post, encoder: Firestore.Encoder())
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully added")
                onComplete?(post.postId)
            }
        }
    }
    
    static func editPost(_ post: Posts){
        try? db.collection("posts")
            .document(post.postId)
            .setData(from: post, encoder: Firestore.Encoder())
        {
            err in
    
            if let err = err {
                print("Error editing document: \(err)")
            } else {
                print("Document successfully edited!")
            }
        }
    }

    static func deletePost (post: Posts){
        db.collection("posts").document(post.postId).delete() {
            err in

            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
