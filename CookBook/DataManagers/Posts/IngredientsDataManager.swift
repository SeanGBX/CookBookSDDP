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
    
    static func loadIngredients(_ ingredientID: String, onComplete: (([Ingredients]) -> Void)?){
        db.collection("ingredients").whereField("postId", isEqualTo: ingredientID).getDocuments(){
            
            (querySnapshot, err) in
            var ingredientList : [Ingredients] = []
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var ingredient = try? document.data(as: Ingredients.self) as! Ingredients
                    
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
    
    static func insertIngredient(_ ingredient: Ingredients){
        var addedDocument = try? db.collection("ingredients").addDocument(from: ingredient, encoder: Firestore.Encoder())
        
        ingredient.ingredientId = String(addedDocument?.documentID ?? "")

        try? db.collection("ingredients")
            .document(String(ingredient.ingredientId))
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
    
    static func editIngredient(_ ingredient: Ingredients){
        try? db.collection("ingredients")
            .document(ingredient.ingredientId)
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

    static func deleteIngredient (ingredient: Ingredients){
        try? db.collection("ingredient").document(ingredient.ingredientId).delete() {
            err in

            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    static func deleteIngredientByPost (ingredients: [Ingredients]){
        for i in ingredients {
            db.collection("ingredients").document(i.ingredientId).delete(){
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
