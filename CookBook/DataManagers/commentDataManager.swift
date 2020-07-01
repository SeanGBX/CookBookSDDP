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
    
    static func loadComments(onComplete: (([PostComment]) -> Void)?){
        db.collection("postComments").getDocuments(){
            
            (querySnapshot, err) in
            var commentList : [PostComment] = []
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var comment = try? document.data(as: PostComment.self) as! PostComment
                    
                    if comment != nil{
                        commentList.append(comment!)
                    }
                }
            }
            onComplete?(commentList)
        }
    }

    static func storeCommentID(_ ID: String) -> String {
        var selectedComment =
            try? db.collection("postComments")
                .document(ID)
        var selectedID = selectedComment?.documentID
        
        return selectedID!
    }

    static func insertComment(_ comment: PostComment, onComplete: ((String)-> Void)?){
        var addedDocument = try? db.collection("postComments").addDocument(from: comment, encoder: Firestore.Encoder())
        
        comment.commentId = String(addedDocument?.documentID ?? "")

        try? db.collection("postComments")
            .document(String(comment.commentId))
            .setData(from: comment, encoder: Firestore.Encoder())
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully added")
                onComplete?(comment.commentId)
            }
        }
    }

    static func editComment(_ comment: PostComment){
        try? db.collection("postComments")
            .document(comment.commentId)
            .setData(from: comment, encoder: Firestore.Encoder())
        {
            err in

            if let err = err {
                print("Error editing document: \(err)")
            } else {
                print("Document successfully edited!")
            }
        }
    }

    static func deleteComment (comment: PostComment){
        db.collection("postComments").document(comment.commentId).delete() {
            err in

            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

}
