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
