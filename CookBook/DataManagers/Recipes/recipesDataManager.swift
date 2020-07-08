//
//  recipesDataManager.swift
//  CookBook
//
//  Created by ITP312Grp2 on 8/7/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class RecipeDataManager: NSObject {
    static let db = Firestore.firestore()
    
    static func loadRecipes(onComplete: (([Posts]) -> Void)?) {
        db.collection("posts").getDocuments() {
            (querySnapshot, err) in
            var recipeList: [Posts] = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            }
            
            else {
                for document in querySnapshot!.documents {
                    var recipe = try? document.data(as: Posts.self) as! Posts
                    
                    if recipe != nil {
                        recipeList.append(recipe!)
                    }
                }
            }
            
            onComplete?(recipeList)
        }
    }

}
