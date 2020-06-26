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
    
    static func createIngredientStepsTable(){
        
        SQLiteDB.sharedInstance.execute(sql:
            "CREATE TABLE IF NOT EXISTS " +
            "IngredientSteps ( " +
            "    ingredientStepId int primary key autoincrement, " +
            "    ingredient text, " +
            "    step text, " +
            "    ingredientImage text, " +
            "    postId int " +
            ")"
        )
        
    }
    
    static func loadIngredientSteps() -> [IngredientSteps]
    {
        let ingredientStepsRows = SQLiteDB.sharedInstance.query(sql:
            "SELECT ingredientStepsId, ingredient, step, " +
            "ingredientImage, postId " +
            "FROM IngredientSteps"
        )
        
        var ingredientStepsList : [IngredientSteps] = []
        for row in ingredientStepsRows {
            ingredientStepsList.append(
                IngredientSteps(
                    postId: row["postId"] as! Int,
                    ingredient: row["ingredient"] as! String,
                    step: row["step"] as! String,
                    ingredientImage: row["ingredientImage"] as! String,
                    ingredientStepId: row["ingredientStepsId"] as! Int
                )
            )
        }
        return ingredientStepsList
    }
    
    static func insertOrReplaceComment(ingredientSteps: IngredientSteps){
        SQLiteDB.sharedInstance.execute(sql:
            "INSERT OR REPLACE INTO IngredientSteps (ingredientStepsId, " +
            "ingredient, step, ingredientImage, postId) " +
            "VALUES (?, ?, ?, ?)",
            parameters: [
                ingredientSteps.ingredientStepId,
                ingredientSteps.ingredient,
                ingredientSteps.step,
                ingredientSteps.ingredientImage,
                ingredientSteps.postId
            ]
        )
    }
    
    static func deleteIngredientStep (ingredientSteps: IngredientSteps){
        SQLiteDB.sharedInstance.execute(sql:
            "DELETE FROM IngredientSteps WHERE ingredientStepId = ?",
            parameters: [ingredientSteps.ingredientStepId]
         )
    }

}
