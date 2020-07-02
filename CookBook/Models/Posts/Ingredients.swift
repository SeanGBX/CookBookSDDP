//
//  Ingredients.swift
//  CookBook
//
//  Created by 182558Z  on 7/2/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class Ingredients: NSObject, Codable {

    var postId: String
    var ingredient: String
    var measureVal: Int
    var measureType: String
    var ingredientImage: String
    var ingredientId: String
    
    
    init (postId: String,  ingredient: String, ingredientImage: String, measureVal: Int, measureType: String,ingredientId: String = "")
    {
        self.ingredient = ingredient
        self.postId = postId
        self.measureVal = measureVal
        self.measureType = measureType
        self.ingredientImage = ingredientImage
        self.ingredientId = ingredientId
    }
    
}
