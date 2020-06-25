//
//  DataManager.swift
//  SDDPProject
//
//  Created by M07-3 on 6/18/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class postsDataManager: NSObject {

    static func createPostTable(){
        
        SQLiteDB.sharedInstance.execute(sql:
            "CREATE TABLE IF NOT EXISTS " +
            "Posts ( " +
            "    postId INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "    recipeName text, " +
            "    username text, " +
            "    mealType text, " +
            "    likes int, " +
            "    healthy int, " +
            "    tagBudget text, " +
            "    tagStyle text, " +
            "    tagPrep text, " +
            "    postImage text " +
            ")"
        )
    }
    
    
    static func loadPosts() -> [Posts]
    {
        let postRows = SQLiteDB.sharedInstance.query(sql:
            "SELECT * FROM Posts"
        )
        
        var postList : [Posts] = []
        for row in postRows {
            postList.append(
                Posts(
                    recipeName: row["recipeName"] as! String,
                    username: row["username"] as! String,
                    mealType: row["mealType"] as! String,
                    likes: row["likes"] as! Int,
                    healthy: row["healthy"] as! Int,
                    tagBudget: row["tagBudget"] as! String,
                    tagStyle: row["tagStyle"] as! String,
                    tagPrep: row["tagPrep"] as! String,
                    postImage: row["postImage"] as! String,
                    postId: row["postId"] as! Int
                )
            )
        }
        return postList
    }
    
    static func selectPostById(id: Int){
        let selectedPost = SQLiteDB.sharedInstance.query(sql:
            "SELECT * FROM Posts WHERE postId = ?",
            parameters: [id]
        )
        
        var postItem : Posts?
        postItem = Posts(
            recipeName: selectedPost["recipeName"] as! String,
            username: selectedPost["username"] as! String,
            mealType: selectedPost["mealType"] as! String,
            likes: selectedPost["likes"] as! Int,
            healthy: selectedPost["healthy"] as! Int,
            tagBudget: selectedPost["tagBudget"] as! String,
            tagStyle: selectedPost["tagStyle"] as! String,
            tagPrep: selectedPost["tagPrep"] as! String,
            postImage: selectedPost["postImage"] as! String,
            postId: selectedPost["postId"] as! Int
        )
        return postItem
    }
    
    static func insertPost(posts: Posts){
        SQLiteDB.sharedInstance.execute(sql:
            "INSERT INTO Posts " +
            "(recipeName, " +
            "username, mealType, likes, healthy, tagBudget, " +
            "tagStyle, tagPrep, postImage) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
            parameters: [
                posts.recipeName,
                posts.username,
                posts.mealType,
                posts.likes,
                posts.healthy,
                posts.tagBudget,
                posts.tagStyle,
                posts.tagPrep,
                posts.postImage
            ]
        )
    }
    
    static func deletePost (posts: Posts){
        SQLiteDB.sharedInstance.execute(sql:
            "DELETE FROM Posts WHERE postId = ?",
            parameters: [posts.postId]
         )
    }
}
