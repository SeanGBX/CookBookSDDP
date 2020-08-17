//
//  FollowingViewController.swift
//  CookBook
//
//  Created by 180725J  on 7/19/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseAuth

class FollowingViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var tableViewFollowing: UITableView!
    
    var followingList :[Followers] = []
    var profileList :[Profile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllFollowing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadAllProfiles()
    }
    
    func loadData() {
        self.tableViewFollowing.reloadData()
    }
    
    func loadAllFollowing() {
        let currentUser = Auth.auth().currentUser
        let currentuid = currentUser?.uid
        
        followDataManager.loadFollowing(currentuid!) {
            flwingdb in
            self.followingList = flwingdb
        }
    }
    
    
    func loadAllProfiles(){
         for i in self.followingList {
            profileDataManager.loadProfile(i.targetAccountUID){
            profiledb in
                self.profileList.append(profiledb[0])
                self.tableViewFollowing.reloadData()
            }
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
        let cell: ProfileCellA = tableView.dequeueReusableCell(withIdentifier: "ProfileCellA", for: indexPath) as! ProfileCellA
        
        let p = profileList[indexPath.row]
        cell.NameLabel?.text = p.displayName
        cell.followerAccountUID = p.UID

        return cell
        
    }
    
}
