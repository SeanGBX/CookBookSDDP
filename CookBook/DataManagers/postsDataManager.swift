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

//    static func createPostTable(){
//
//        SQLiteDB.sharedInstance.execute(sql:
//            "CREATE TABLE IF NOT EXISTS " +
//            "Posts ( " +
//            "    postId INTEGER PRIMARY KEY AUTOINCREMENT, " +
//            "    recipeName text, " +
//            "    username text, " +
//            "    mealType text, " +
//            "    likes int, " +
//            "    healthy int, " +
//            "    tagBudget text, " +
//            "    tagStyle text, " +
//            "    tagPrep text, " +
//            "    postImage text " +
//            ")"
//        )
//    }
    
    static func loadPosts(onComplete: (([Posts])-> Void)?){
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
    
    
//    static func loadPosts() -> [Posts]
//    {
//        let postRows = SQLiteDB.sharedInstance.query(sql:
//            "SELECT * FROM Posts"
//        )
//
//        var postList : [Posts] = []
//        for row in postRows {
//            postList.append(
//                Posts(
//                    recipeName: row["recipeName"] as! String,
//                    username: row["username"] as! String,
//                    mealType: row["mealType"] as! String,
//                    likes: row["likes"] as! Int,
//                    healthy: row["healthy"] as! Int,
//                    tagBudget: row["tagBudget"] as! String,
//                    tagStyle: row["tagStyle"] as! String,
//                    tagPrep: row["tagPrep"] as! String,
//                    postImage: row["postImage"] as! String,
//                    postId: row["postId"] as! Int
//                )
//            )
//        }
//        return postList
//    }
    
//    static func selectPostById(id: Int) -> [Posts] {
//        let selectedPost = SQLiteDB.sharedInstance.query(sql:
//            "SELECT * FROM Posts WHERE postId = ?",
//            parameters: [id]
//        )
//
//        var postItemList : [Posts] = []
//        for row in selectedPost{
//            postItemList.append(Posts(
//                recipeName: row["recipeName"] as! String,
//                username: row["username"] as! String,
//                mealType: row["mealType"] as! String,
//                likes: row["likes"] as! Int,
//                healthy: row["healthy"] as! Int,
//                tagBudget: row["tagBudget"] as! String,
//                tagStyle: row["tagStyle"] as! String,
//                tagPrep: row["tagPrep"] as! String,
//                postImage: row["postImage"] as! String,
//                postId: row["postId"] as! Int
//            ))
//        }
//        return postItemList
//    }
    
    static func insertOrReplacePost(_ post: Posts){
        try? db.collection("posts")
            .document(String(post.postId))
            .setData(from: post, encoder: Firestore.Encoder())
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully added")
            }
        }
    }
    
//    static func insertPost(posts: Posts){
//        SQLiteDB.sharedInstance.execute(sql:
//            "INSERT INTO Posts " +
//            "(recipeName, " +
//            "username, mealType, likes, healthy, tagBudget, " +
//            "tagStyle, tagPrep, postImage) " +
//            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
//            parameters: [
//                posts.recipeName,
//                posts.username,
//                posts.mealType,
//                posts.likes,
//                posts.healthy,
//                posts.tagBudget,
//                posts.tagStyle,
//                posts.tagPrep,
//                posts.postImage
//            ]
//        )
//    }
    
    static func deletePost (posts: Posts){
        SQLiteDB.sharedInstance.execute(sql:
            "DELETE FROM Posts WHERE postId = ?",
            parameters: [posts.postId]
         )
    }
}
