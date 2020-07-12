//
//  likePostDataManager.swift
//  CookBook
//
//  Created by 182558Z  on 7/11/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class likePostDataManager: NSObject {
    
    static let db = Firestore.firestore()
    
    static func insertLike(_ like: LikePost){
        var addedDocument = try? db.collection("postLikes").addDocument(from: like, encoder: Firestore.Encoder())
        
        like.likeId = String(addedDocument?.documentID ?? "")

        try? db.collection("postLikes")
            .document(String(like.likeId))
            .setData(from: like, encoder: Firestore.Encoder())
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully added")

            }
        }
    }
    
    static func deleteLike (_ likeList: [LikePost]){
        for i in likeList{
            db.collection("postLikes").document(i.likeId).delete() {
                err in

                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    
    static func loadUniqueLikes(_ postID: String, _ username: String, onComplete: (([LikePost]) -> Void)?){
        db.collection("postLikes").whereField("postId", isEqualTo: postID).whereField("username", isEqualTo: username).getDocuments(){
            
            (querySnapshot, err) in
            var likeList : [LikePost] = []
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var like = try? document.data(as: LikePost.self) as! LikePost
                    
                    if like != nil{
                        likeList.append(like!)
                    }
                }
            }
            onComplete?(likeList)
        }
    }
    
    static func loadLikesByPost(_ postID: String, onComplete: (([LikePost]) -> Void)?){
        db.collection("postLikes").whereField("postId", isEqualTo: postID).getDocuments(){
            
            (querySnapshot, err) in
            var likeList : [LikePost] = []
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var like = try? document.data(as: LikePost.self) as! LikePost
                    
                    if like != nil{
                        likeList.append(like!)
                    }
                }
            }
            onComplete?(likeList)
        }
    }

}
