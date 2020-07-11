//
//  Conversations.swift
//  CookBook
//
//  Created by Sean Gwee on 9/7/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class Conversations: NSObject, Codable{
    var currUserId: String
    var otherUserId: String
    var otherUserName: String
    var imageName: String
    var messages: [[String: String]]
    
    init(currUserId: String, otherUserId: String, otherUserName: String, imageName: String, messages: [[String: String]] = [[
        "date": "",
        "message": "",
        "is_read": "false"]]
    )
    {
        self.currUserId = currUserId
        self.otherUserId = otherUserId
        self.otherUserName = otherUserName
        self.imageName = imageName
        self.messages = messages
    }
}
