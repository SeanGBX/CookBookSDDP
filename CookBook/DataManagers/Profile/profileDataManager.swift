//
//  profileDataManager.swift
//  CookBook
//
//  Created by 180725J  on 7/14/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class profileDataManager: NSObject {
    
    static let db = Firestore.firestore()
    
    //get array of all profile objects
    static func loadAllProfiles(onComplete: (([Profile]) -> Void)?){
    db.collection("profiles").getDocuments(){
        
        (querySnapshot, err) in
        var profileList : [Profile] = []
        
        if let err = err{
            print("Error getting documents: \(err)")
        }
        else{
            for document in querySnapshot!.documents{
                var profile = try? document.data(as: Profile.self) as! Profile
                
                if profile != nil{
                    profileList.append(profile!)
                }
            }
        }
        onComplete?(profileList)
        }
    }
    
    //get one profile object of this UID
    static func loadProfile(_ profileUID: String, onComplete: (([Profile]) -> Void)?){
    db.collection("profiles").whereField("UID", isEqualTo: profileUID).getDocuments(){
        
        (querySnapshot, err) in
        var profileList : [Profile] = []
        
        if let err = err{
            print("Error getting documents: \(err)")
        }
        else{
            for document in querySnapshot!.documents{
                var profile = try? document.data(as: Profile.self) as! Profile
                
                if profile != nil{
                    profileList.append(profile!)
                }
            }
        }
        onComplete?(profileList)
        }
    }
    
    //calculate number of following this UID has
    static func calculateFollowing(_ profileUID: String, onComplete: ((Int) -> Void)?){
        db.collection("followers").whereField("followerAccountUID", isEqualTo: profileUID).getDocuments(){
        
        (querySnapshot, err) in
        var flwingList : [Followers] = []
        
        if let err = err{
            print("Error getting documents: \(err)")
        }
        else{
            for document in querySnapshot!.documents{
                var flwing = try? document.data(as: Followers.self) as! Followers
                
                if flwing != nil{
                    flwingList.append(flwing!)
                }
            }
        }
        onComplete?(flwingList.count)
        }
    }
    
    //calculate number of followers this UID has
    static func calculateFollowers(_ profileUID: String, onComplete: ((Int) -> Void)?){
        db.collection("followers").whereField("targetAccountUID", isEqualTo: profileUID).getDocuments(){
        
        (querySnapshot, err) in
        var flwList : [Followers] = []
        
        if let err = err{
            print("Error getting documents: \(err)")
        }
        else{
            for document in querySnapshot!.documents{
                var flw = try? document.data(as: Followers.self) as! Followers
                
                if flw != nil{
                    flwList.append(flw!)
                }
            }
        }
        onComplete?(flwList.count)
        }
    }
    
    //calculate number of posts this UID has
    static func calculatePosts(_ profileUID: String, onComplete: ((Int) -> Void)?){
        db.collection("posts").whereField("username", isEqualTo: profileUID).whereField("postComplete", isEqualTo: "1").getDocuments(){
        
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
        onComplete?(postList.count)
        }
    }
    
    //get array of posts this UID has
    static func getUserPosts(_ profileUID: String, onComplete: (([Posts]) -> Void)?){
        db.collection("posts").whereField("username", isEqualTo: profileUID).whereField("postComplete", isEqualTo: "1").getDocuments(){
        
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
    
    //create Profile Object
    static func insertProfile(_ profile: Profile){
        //create document and set values
        try? db.collection("profiles")
            .document(String(profile.UID))
            .setData(from: profile, encoder: Firestore.Encoder())
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully added")
            }
        }
    }
    
    //delete Profile Object
    static func deleteProfile (profile: Profile){
        //delete profile by uid
        db.collection("profiles").document(profile.UID).delete() {
            err in

            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    //set Profile Object with new values
    static func editProfile(_ profile: Profile){
        //set profile values by uid
        try? db.collection("profiles")
            .document(profile.UID)
            .setData(from: profile, encoder: Firestore.Encoder())
        {
            err in

            if let err = err {
                print("Error editing document: \(err)")
            } else {
                print("Document successfully edited!")
            }
        }
    }
    
}
