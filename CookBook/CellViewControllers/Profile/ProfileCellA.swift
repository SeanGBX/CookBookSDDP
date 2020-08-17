//
//  ProfileCellA.swift
//  CookBook
//
//  Created by 180725J  on 8/14/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class ProfileCellA: UITableViewCell {

    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    
    var followerAccountUID: String?
    var uniqueFollower: [Followers]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func FollowTapped(_ sender: Any) {
        loadUniqueFollowing()
    }
    
    func loadUniqueFollowing() {
        let currentUser = Auth.auth().currentUser
        let currentuid = currentUser?.uid
        
        followDataManager.deleteFollower(currentuid!,targetAccountUID: followerAccountUID!, onComplete: {
            follower in
            self.uniqueFollower = follower
            followDataManager.actuallyDeleteFollower(follower: self.uniqueFollower!)
            
        })
    }
    
}
