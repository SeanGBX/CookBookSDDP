//
//  Posts.swift
//  SDDPProject
//
//  Created by M07-3 on 6/13/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class Posts: NSObject {

    var recipeName: String
    var username: String
    var mealType: String
    var likes: Int
    var healthy: Int
    var tagBudget: String
    var tagStyle: String
    var tagPrep: String
    var postImage: String
    var postId: Int
    
    init (recipeName: String, username: String, mealType: String, likes: Int, healthy: Int, tagBudget: String, tagStyle: String, tagPrep: String, postImage: String, postId: Int = -1)
    {
        self.recipeName = recipeName
        self.username = username
        self.mealType = mealType
        self.likes = likes
        self.healthy = healthy
        self.tagBudget = tagBudget
        self.tagPrep = tagPrep
        self.tagStyle = tagStyle
        self.postImage = postImage
        self.postId = postId
    }
    
}
