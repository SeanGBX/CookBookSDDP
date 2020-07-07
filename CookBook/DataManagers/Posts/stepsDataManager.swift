//
//  stepsDataManager.swift
//  CookBook
//
//  Created by 182558Z  on 7/7/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class stepsDataManager: NSObject {
    
    static let db = Firestore.firestore()
    
    static func loadSteps(_ postID: String, onComplete: (([Steps]) -> Void)?){
        db.collection("steps").whereField("postId", isEqualTo: postID).getDocuments(){
            
            (querySnapshot, err) in
            var stepList : [Steps] = []
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var step = try? document.data(as: Steps.self) as! Steps
                    
                    if step != nil{
                        stepList.append(step!)
                    }
                }
            }
            onComplete?(stepList)
        }
    }

    static func storeStepID(_ ID: String) -> String {
        var selectedStep =
            try? db.collection("steps")
                .document(ID)
        var selectedID = selectedStep?.documentID
        
        return selectedID!
    }

    static func insertStep(_ step: Steps){
        var addedDocument = try? db.collection("steps").addDocument(from: step, encoder: Firestore.Encoder())
        
        step.stepId = String(addedDocument?.documentID ?? "")

        try? db.collection("steps")
            .document(String(step.stepId))
            .setData(from: step, encoder: Firestore.Encoder())
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully added")
            }
        }
    }

    static func editStep(_ step: Steps){
        try? db.collection("steps")
            .document(step.stepId)
            .setData(from: step, encoder: Firestore.Encoder())
        {
            err in

            if let err = err {
                print("Error editing document: \(err)")
            } else {
                print("Document successfully edited!")
            }
        }
    }

    static func deleteComment (step: Steps) {
        db.collection("steps").document(step.stepId).delete() {
            err in

            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    static func deleteStepByPost (steps: [Steps]){
        for s in steps {
            db.collection("steps").document(s.stepId).delete(){
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
