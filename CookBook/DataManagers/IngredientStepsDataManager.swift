//
//  IngredientStepsDataManager.swift
//  SDDPProject
//
//  Created by M07-3 on 6/19/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class IngredientStepsDataManager: NSObject {
    
    static let db = Firestore.firestore()
    
    static func loadIngredients(onComplete: (([IngredientSteps]) -> Void)?){
        db.collection("ingredients").getDocuments(){
            
            (querySnapshot, err) in
            var ingredientList : [IngredientSteps] = []
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var ingredient = try? document.data(as: IngredientSteps.self) as! IngredientSteps
                    
                    if ingredient != nil{
                        ingredientList.append(ingredient!)
                    }
                }
            }
            onComplete?(ingredientList)
        }
    }
    
    static func storeIngredientID(_ ID: String) -> String {
        var selectedIngredient =
            try? db.collection("ingredients")
                .document(ID)
        var selectedID = selectedIngredient?.documentID
        
        return selectedID!
    }
    
    static func insertIngredient(_ ingredient: IngredientSteps, onComplete: ((String)-> Void)?){
        var addedDocument = try? db.collection("ingredients").addDocument(from: ingredient, encoder: Firestore.Encoder())
        
        ingredient.ingredientStepId = String(addedDocument?.documentID ?? "")

        try? db.collection("ingredients")
            .document(String(ingredient.ingredientStepId))
            .setData(from: ingredient, encoder: Firestore.Encoder())
        {
            err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully added")
                onComplete?(ingredient.ingredientStepId)
            }
        }
    }
    
    static func editIngredient(_ ingredient: IngredientSteps){
        try? db.collection("ingredients")
            .document(ingredient.ingredientStepId)
            .setData(from: ingredient, encoder: Firestore.Encoder())
        {
            err in
    
            if let err = err {
                print("Error editing document: \(err)")
            } else {
                print("Document successfully edited!")
            }
        }
    }

    static func deleteIngredient (ingredient: IngredientSteps){
        db.collection("ingredient").document(ingredient.ingredientStepId).delete() {
            err in

            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

}
