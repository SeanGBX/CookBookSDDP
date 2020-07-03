//
//  Steps.swift
//  CookBook
//
//  Created by 182558Z  on 7/2/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class Steps: NSObject, Codable {
    
    var postId: String
    var stepDesc: String
    var stepId: String
    
    
    init (postId: String, stepDesc: String, stepId: String = "")
    {
        self.postId = postId
        self.stepDesc = stepDesc
        self.stepId = stepId
    }
}
