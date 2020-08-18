//
//  followDataManager.swift
//  CookBook
//
//  Created by 180725J  on 7/19/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class followDataManager: NSObject {
    static let db = Firestore.firestore()
    
    //get array of follower objects where UID is the targetAccountUID
    static func loadFollowers(_ profileUID: String, onComplete: (([Followers]) -> Void)?){
    db.collection("followers").whereField("targetAccountUID", isEqualTo: profileUID).getDocuments(){
        
        (querySnapshot, err) in
        var followerList : [Followers] = []
        
        if let err = err{
            print("Error getting documents: \(err)")
        }
        else{
            for document in querySnapshot!.documents{
                var follower = try? document.data(as: Followers.self) as! Followers
                
                if follower != nil{
                    followerList.append(follower!)
                }
            }
        }
        onComplete?(followerList)
        }
    }
    
    //get array of follower objects where UID is the followerAccountUID
    static func loadFollowing(_ profileUID: String, onComplete: (([Followers]) -> Void)?){
    db.collection("followers").whereField("followerAccountUID", isEqualTo: profileUID).getDocuments(){
        
        (querySnapshot, err) in
        var followingList : [Followers] = []
        
        if let err = err{
            print("Error getting documents: \(err)")
        }
        else{
            for document in querySnapshot!.documents{
                var following = try? document.data(as: Followers.self) as! Followers
                
                if following != nil{
                    followingList.append(following!)
                }
            }
        }
        onComplete?(followingList)
        }
    }
    
    //create follower object
    static func insertFollower(_ follower: Followers){
        var addedDocument = try? db.collection("followers").addDocument(from: follower, encoder: Firestore.Encoder())
        
        let docID = String(addedDocument?.documentID ?? "")
        
        follower.followerID = docID

        try? db.collection("followers")
            .document(String(follower.followerID))
            .setData(from: follower, encoder: Firestore.Encoder())
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Follower successfully added")
            }
        }
    }
    
    //retrieve follower object that need to be deleted
    static func deleteFollower(_ followerAccountUID: String, targetAccountUID: String, onComplete: (([Followers]) -> Void)?){
        db.collection("followers").whereField("followerAccountUID", isEqualTo: followerAccountUID).whereField("targetAccountUID", isEqualTo: targetAccountUID).getDocuments(){
           
           (querySnapshot, err) in
           var followingList : [Followers] = []
           
           if let err = err{
               print("Error getting documents: \(err)")
           }
           else{
               for document in querySnapshot!.documents{
                   var following = try? document.data(as: Followers.self) as! Followers
                   
                   if following != nil{
                       followingList.append(following!)
                   }
               }
           }
           onComplete?(followingList)
           }
       }
    
    //delete follower object
    static func actuallyDeleteFollower (follower: [Followers]){
        for i in follower {
            db.collection("followers").document(i.followerID).delete() {
            err in

            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                }
            }
        }
    }
    
    

}
