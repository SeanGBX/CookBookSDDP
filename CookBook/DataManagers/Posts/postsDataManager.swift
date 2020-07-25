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
    
    static func loadSpecificPost(_ postID: String, onComplete: (([Posts]) -> Void)?){
        db.collection("posts").whereField("postId", isEqualTo: postID).getDocuments(){
            
            (querySnapshot, err) in
            var specificPostList : [Posts] = []
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var post = try? document.data(as: Posts.self) as! Posts
                    
                    
                    if post != nil{
                        specificPostList.append(post!)
                    }
                }
            }
            onComplete?(specificPostList)
        }
    }
    
    static func loadCompletePosts(onComplete: (([Posts]) -> Void)?){
        db.collection("posts").whereField("postComplete", isEqualTo: "1").getDocuments(){
            
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
    
    static func editPost(_ postID: String, _ post: Posts, onComplete: ((String)-> Void)?){
        post.postId = postID
        try? db.collection("posts")
            .document(postID)
            .setData(from: post, encoder: Firestore.Encoder())
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully fixed")
                onComplete?(postID)
            }
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
    
    static func FinishPost(_ postID: String, _ post: Posts){
        try? db.collection("posts")
            .document(postID)
            .updateData([
                "tagBudget": post.tagBudget,
                "tagStyle": post.tagStyle,
                "tagPrep": post.tagPrep,
                "postComplete": post.postComplete
                ])
        {
            err in
    
            if let err = err {
                print("Error editing document: \(err)")
            } else {
                print("Document successfully edited!")
            }
        }
    }

    static func deletePost (_ postID: String){
        db.collection("posts").document(postID).delete() {
            err in

            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    static func insertPostLike(_ postID: String, onComplete: (()-> Void)?){
        let post = db
        try? db.collection("posts")
            .document(postID)
            .updateData([
                "likes": FieldValue.increment(Int64(1))
                ])
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully fixed")
                onComplete?()
            }
        }
    }
    
    static func deletePostLike(_ postID: String, onComplete: (()-> Void)?){
        try? db.collection("posts")
            .document(postID)
            .updateData([
                "likes": FieldValue.increment(Int64(-1))
                ])
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully fixed")
                onComplete?()
            }
        }
    }
    
    static func insertPostHealthy(_ postID: String, onComplete: (()-> Void)?){
        try? db.collection("posts")
            .document(postID)
            .updateData([
                "healthy": FieldValue.increment(Int64(1))
                ])
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully fixed")
                onComplete?()
            }
        }
    }
    
    static func deletePostHealthy(_ postID: String, onComplete: (()-> Void)?){
        try? db.collection("posts")
            .document(postID)
            .updateData([
                "healthy": FieldValue.increment(Int64(-1))
                ])
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully fixed")
                onComplete?()
            }
        }
    }
}
