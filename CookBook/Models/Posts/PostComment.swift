//
//  PostComment.swift
//  SDDPProject
//
//  Created by M07-3 on 6/15/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class PostComment: NSObject, Codable {
    
    var postId: String
    var comment: String
    var username: String
    var commentId: String
    
    
    init (postId: String, comment: String, username: String,
          commentId: String = "")
    {
        self.postId = postId
        self.comment = comment
        self.username = username
        self.commentId = commentId
    }

}

