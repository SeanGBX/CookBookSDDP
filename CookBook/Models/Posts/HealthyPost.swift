//
//  HealthyPost.swift
//  CookBook
//
//  Created by 182558Z  on 7/11/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class HealthyPost: NSObject, Codable {
    
    var postId: String
    var username: String
    var healthyId: String
    
    
    init (postId: String, username: String, healthyId: String = "")
    {
        self.postId = postId
        self.username = username
        self.healthyId = healthyId
    }

}
