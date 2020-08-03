//
//  Followers.swift
//  CookBook
//
//  Created by 180725J  on 7/19/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class Followers: NSObject, Codable {
    
    var followerAccountUID : String
    var targetAccountUID: String
    var followerID: String
    
    init(followerAccountUID: String, targetAccountUID: String, followerID: String){
        self.followerAccountUID = followerAccountUID
        self.targetAccountUID = targetAccountUID
        self.followerID = followerID
    }
}
