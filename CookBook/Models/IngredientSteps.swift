//
//  IngredientSteps.swift
//  SDDPProject
//
//  Created by M07-3 on 6/15/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class IngredientSteps: NSObject, Codable {
    
    var postId: Int
    var ingredient: String
    var step: String
    var ingredientImage: String
    var ingredientStepId: Int
    
    
    init (postId: Int,  ingredient: String, step: String,
          ingredientImage: String, ingredientStepId: Int = 0)
    {
        self.ingredient = ingredient
        self.step = step
        self.postId = postId
        self.ingredientImage = ingredientImage
        self.ingredientStepId = ingredientStepId
    }

}
