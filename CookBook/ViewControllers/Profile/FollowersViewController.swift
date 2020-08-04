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

        
        loadAllProfiles()
        
        //print("profilenames:",self.profileList[0].displayName)
        
    }
    
    func loadAllProfiles() {
        profileDataManager.loadAllProfiles { profiledb in
            self.profileList = profiledb
            self.tableViewFollowers.reloadData()
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
        let cell: ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
        let p = profileList[indexPath.row]
        cell.NameLabel?.text = p.displayName

        return cell
        
    }
    
}
