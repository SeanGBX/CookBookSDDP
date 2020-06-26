//
//  commentDataManager.swift
//  SDDPProject
//
//  Created by M07-3 on 6/19/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class commentDataManager: NSObject {
    
    static let db = Firestore.firestore()
    
    static func createCommentTable(){
        
        SQLiteDB.sharedInstance.execute(sql:
            "CREATE TABLE IF NOT EXISTS " +
            "PostComments ( " +
            "    commentId int primary key autoincrement, " +
            "    comment text, " +
            "    username text, " +
            "    postId int " +
            ")"
        )
        
    }
    
    static func loadComments() -> [PostComment]
    {
        let commentRows = SQLiteDB.sharedInstance.query(sql:
            "SELECT commentId, comment, username, postId " +
            "FROM PostComments"
        )
        
        var commentList : [PostComment] = []
        for row in commentRows {
            commentList.append(
                PostComment(
                    postId: row["postId"] as! Int,
                    comment: row["comment"] as! String,
                    username: row["username"] as! String,
                    commentId: row["commentId"] as! Int
                )
            )
        }
        return commentList
    }
    
    static func insertOrReplaceComment(postComment: PostComment){
        SQLiteDB.sharedInstance.execute(sql:
            "INSERT OR REPLACE INTO PostComments (commentId, " +
            "comment, username, postId) " +
            "VALUES (?, ?, ?, ?)",
            parameters: [
                postComment.commentId,
                postComment.comment,
                postComment.username,
                postComment.postId
            ]
        )
    }
    
    static func deleteComment (postComment: PostComment){
        SQLiteDB.sharedInstance.execute(sql:
            "DELETE FROM PostComments WHERE commentId = ?",
            parameters: [postComment.commentId]
         )
    }

}
