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
    
    //load All Posts
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
    
    //load post by postId
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
    
    //load only complete posts
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
    
    //load posts in descending order of healthy count
    static func loadCompletePostsByHealthy(onComplete: (([Posts]) -> Void)?){
        db.collection("posts").whereField("postComplete", isEqualTo: "1").order(by: "healthy", descending: true).getDocuments(){
            
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
    
    //edit post
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
    
    //retrieve post id and store
    static func storePostID(_ ID: String) -> String {
        var selectedPost =
            try? db.collection("posts")
                .document(ID)
        var selectedID = selectedPost?.documentID
        
        return selectedID!
    }
    
    //add post
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
    
    //update tags and set post as complete
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

    //delete post
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
    
    //like post counter add
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
    
    //like post counter reduce
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
    
    //healthy post counter add
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
    
    //healthy post counter reduce
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
