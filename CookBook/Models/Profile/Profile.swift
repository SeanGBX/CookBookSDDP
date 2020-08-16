//
//  Profile.swift
//  CookBook
//
//  Created by 180725J  on 7/14/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class Profile: NSObject, Codable {
    
    var UID: String
    var email: String
    var imageName: String
    var displayName: String
    var bio: String
    
    
    init(UID: String, email: String, imageName: String, displayName: String, bio: String){
        self.UID = UID
        self.email = email
        self.imageName = imageName
        self.displayName = displayName
        self.bio = bio
    }
    
}
