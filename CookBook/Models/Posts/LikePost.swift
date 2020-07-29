//
//  LikePost.swift
//  CookBook
//
//  Created by 182558Z  on 7/11/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class LikePost: NSObject, Codable {
    
    var postId: String
    var username: String
    var budget: String
    var prepTime: String
    var cookStyle: String
    var likeId: String
    
    
    init (postId: String, username: String, budget: String, prepTime: String, cookStyle: String, likeId: String = "")
    {
        self.postId = postId
        self.username = username
        self.budget = budget
        self.prepTime = prepTime
        self.cookStyle = cookStyle
        self.likeId = likeId
    }

}
