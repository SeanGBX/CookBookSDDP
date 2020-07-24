//
//  Followers.swift
//  CookBook
//
//  Created by 180725J  on 7/19/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class Followers: NSObject, Codable {
    
    var mainAccountUID : String
    var followedByAccountUID: String
    var followerID: String
    
    init(mainAccountUID: String, followedByAccountUID: String, followerID: String){
        self.mainAccountUID = mainAccountUID
        self.followedByAccountUID = followedByAccountUID
        self.followerID = followerID
    }
}
