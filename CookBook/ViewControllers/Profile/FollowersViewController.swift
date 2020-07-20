//
//  FollowersViewController.swift
//  CookBook
//
//  Created by 180725J  on 7/19/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class FollowersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewFollowers: UITableView!
    
    
    var profileList :[Profile] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //loadAllProfiles()
        profileList.append(Profile(UID:"",email:"",displayName:"HELO",bio: ""))
        profileList.append(Profile(UID:"",email:"",displayName:"HELO",bio: ""))
        profileList.append(Profile(UID:"",email:"",displayName:"HELO",bio: ""))
        //print("profilenames:",self.profileList[0].displayName)
        
    }
    
    func loadAllProfiles() {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        profileDataManager.loadProfile(uid!) { profiledb in
            self.profileList = profiledb
            print(self.profileList[0].displayName)
        }
    }

    
    func tableView(_ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int
    {
        return profileList.count
    }
    
    
    func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        
        let p = profileList[indexPath.row]
        cell.detailTextLabel?.text = p.displayName

        return cell
        
    }
    
}
