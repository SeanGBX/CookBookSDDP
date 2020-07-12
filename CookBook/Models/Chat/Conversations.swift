//
//  Conversations.swift
//  CookBook
//
//  Created by Sean Gwee on 9/7/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class Conversations: NSObject, Codable{
    var firstUserId: String
    var secondUserId: String
    var firstUserName: String
    var secondUserName: String
    var imageName: String
    var messages: [[String: String]]
    
    init(firstUserId: String, secondUserId: String, firstUserName: String, secondUserName: String, imageName: String, messages: [[String: String]] = [[
        "date": "",
        "message": "",
        "is_read": "false",
        "sentBy": ""]]
    )
    {
        self.firstUserId = firstUserId
        self.secondUserId = secondUserId
        self.firstUserName = firstUserName
        self.secondUserName = secondUserName
        self.imageName = imageName
        self.messages = messages
    }
}
