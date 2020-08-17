//
//  OthersProfileViewController.swift
//  CookBook
//
//  Created by 180725J  on 8/14/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseAuth

class OthersProfileViewController: UIViewController {
    
    @IBOutlet weak var displayname: UILabel!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var postnum: UILabel!
    @IBOutlet weak var flwnum: UIButton!
    @IBOutlet weak var flwingnum: UIButton!
    
    @IBOutlet weak var flwbtn: UIButton!
    @IBOutlet weak var msgbtn: UIButton!
    
    var otherUser: Posts?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOthersProfile()

        // Do any additional setup after loading the view.
    }
    

    func loadOthersProfile() {
        //set displayname and bio

        let otheruid = otherUser!.username
        let uid = otheruid
        profileDataManager.loadProfile(uid) { profiledb in
            self.displayname.text = profiledb[0].displayName
            self.bio.text = profiledb[0].bio
        }
        //set post num
        profileDataManager.calculatePosts(uid) { posts in
            self.postnum.text = String(posts)
            print("TOTAL POST:",self.postnum.text)
        }
    }
    
    
    @IBAction func followTapped(_ sender: Any) {
        let currentUser = Auth.auth().currentUser
        let currentuid = currentUser?.uid
        
        let newflw = Followers(followerAccountUID: currentuid!, targetAccountUID: otherUser!.username, followerID: "0")
        followDataManager.insertFollower(newflw)
    }
    
    
}
