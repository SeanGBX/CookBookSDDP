//
//  healthyPostDataManager.swift
//  CookBook
//
//  Created by 182558Z  on 7/11/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class healthyPostDataManager: NSObject {
    
    static let db = Firestore.firestore()
    
    //add healthy
    static func insertHealthy(_ healthy: HealthyPost){
        var addedDocument = try? db.collection("postHealthy").addDocument(from: healthy, encoder: Firestore.Encoder())
        
        healthy.healthyId = String(addedDocument?.documentID ?? "")

        try? db.collection("postHealthy")
            .document(String(healthy.healthyId))
            .setData(from: healthy, encoder: Firestore.Encoder())
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully added")

            }
        }
    }
    
    //delete healthy
    static func deleteHealthy (_ healthyList: [HealthyPost]){
        for i in healthyList{
            db.collection("postHealthy").document(i.healthyId).delete() {
                err in

                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    
    //load healthy by user and post
    static func loadUniqueHealthy(_ postID: String, _ username: String, onComplete: (([HealthyPost]) -> Void)?){
        db.collection("postHealthy").whereField("postId", isEqualTo: postID).whereField("username", isEqualTo: username).getDocuments(){
            
            (querySnapshot, err) in
            var healthyList : [HealthyPost] = []
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var healthy = try? document.data(as: HealthyPost.self) as! HealthyPost
                    
                    if healthy != nil{
                        healthyList.append(healthy!)
                    }
                }
            }
            onComplete?(healthyList)
        }
    }
    
    //load healthy by post
    static func loadHealthyByPost(_ postID: String, onComplete: (([HealthyPost]) -> Void)?){
        db.collection("postHealthy").whereField("postId", isEqualTo: postID).getDocuments(){
            
            (querySnapshot, err) in
            var healthyList : [HealthyPost] = []
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var healthy = try? document.data(as: HealthyPost.self) as! HealthyPost
                    
                    if healthy != nil{
                        healthyList.append(healthy!)
                    }
                }
            }
            onComplete?(healthyList)
        }
    }

}
