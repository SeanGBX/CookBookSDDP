	//
//  Ingredients.swift
//  CookBook
//
//  Created by 182558Z  on 7/2/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class IngredientSteps: NSObject, Codable {

    var postId: String
    var ingredient: String
    var step: String
    var measureVal: Int
    var measureType: String
    var ingredientImage: String
    var ingredientStepId: String
    
    
    init (postId: String,  ingredient: String, step: String, ingredientImage: String, measureVal: Int, measureType: String, ingredientStepId: String = "")
    {
        self.ingredient = ingredient
        self.step = step
        self.postId = postId
        self.measureVal = measureVal
        self.measureType = measureType
        self.ingredientImage = ingredientImage
        self.ingredientStepId = ingredientStepId
    }
    
}
