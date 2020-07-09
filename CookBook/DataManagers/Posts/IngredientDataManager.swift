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

class IngredientsDataManager: NSObject {
    
    static let db = Firestore.firestore()
    
    static func loadIngredients(_ ingredientID: String, onComplete: (([IngredientSteps]) -> Void)?){
        db.collection("ingredients").whereField("postId", isEqualTo: ingredientID).getDocuments(){
            
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
    
    static func loadOnlySteps(_ ingredientID: String, onComplete: (([String]) -> Void)?){
        db.collection("ingredients").whereField("postId", isEqualTo: ingredientID).getDocuments(){
            
            (querySnapshot, err) in
            var ingredientList : [String] = []
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var ingredient = try? document.data(as: IngredientSteps.self) as! IngredientSteps
                    
                    if ingredient != nil{
                        ingredientList.append(ingredient!.step)
                    }
                }
            }
            onComplete?(ingredientList)
        }
    }
    
    static func loadCompleteIngredients(_ ingredientID: String, onComplete: (([IngredientSteps]) -> Void)?){
        db.collection("ingredients").whereField("postId", isEqualTo: ingredientID).getDocuments(){
            
            (querySnapshot, err) in
            var ingredientList : [IngredientSteps] = []
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var ingredient = try? document.data(as: IngredientSteps.self) as! IngredientSteps
                    
                    if ingredient != nil{
                        if (ingredient!.ingredient != ""){
                            ingredientList.append(ingredient!)
                        }
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
    
    static func insertIngredient(_ ingredient: IngredientSteps){
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

    static func deleteIngredient (_ ingredientID: String){
        try? db.collection("ingredients").document(ingredientID).delete() {
            err in

            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    static func deleteIngredientByPost (ingredients: [IngredientSteps]){
        for i in ingredients {
            db.collection("ingredients").document(i.ingredientStepId).delete(){
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
