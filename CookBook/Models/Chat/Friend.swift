//
//  Friend.swift
//  CookBookSDDP
//
//  Created by Sean Gwee on 25/6/20.
//  Copyright © 2020 Sean Gwee. All rights reserved.
//

import UIKit

class Friend: NSObject, Codable {
    var friendName: String
    var friendText: String
    var imageName: String
    var friendId: String
    
    init(friendName: String, friendText: String, imageName: String, friendId : String = ""){
        self.friendName = friendName
        self.friendText = friendText
        self.imageName     = imageName
        self.friendId = friendId
    }

}
        
