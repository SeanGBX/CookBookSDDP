//
//  Following.swift
//  CookBook
//
//  Created by 180725J  on 7/19/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class Following: NSObject, Codable {
    
    var mainAccountUID : String
    var followingAccountUID: String
    var followingID: String
       
    init(mainAccountUID: String, followingAccountUID: String, followingID: String){
           self.mainAccountUID = mainAccountUID
           self.followingAccountUID = followingAccountUID
        self.followingID = followingID
       }
}
