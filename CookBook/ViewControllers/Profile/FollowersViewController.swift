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
    
    
    var followerList :[Followers] = []
    var profileList :[Profile] = []

    override func viewDidLoad() {
        super.viewDidLoad()    
        loadAllFollowers()
    }
    
    func loadData() {
        self.tableViewFollowers.reloadData()
    }
    
    //load followers of UID
    func loadAllFollowers() {
        let currentUser = Auth.auth().currentUser
        let currentuid = currentUser?.uid
        
        followDataManager.loadFollowers(currentuid!) {
            flwdb in
            self.followerList = flwdb
            
            for i in self.followerList {
            profileDataManager.loadProfile(i.followerAccountUID){
            profiledb in
                self.profileList.append(profiledb[0])
                self.tableViewFollowers.reloadData()
            }
        }
    }
}
    
    //tableview rows
    func tableView(_ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int
    {
        return profileList.count
    }
    
    //set cell data
    func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
            
        let p = profileList[indexPath.row]
        cell.NameLabel?.text = p.displayName
        cell.followerAccountUID = p.UID
        cell.ImageView.kf.setImage(with: URL(string: p.imageName), placeholder: UIImage(named: "defaultprofile"))

        return cell
        
    }
    
    //cell onselect go to profilepage
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "OthersProfile") as! OthersProfileViewController
        let p = profileList[indexPath.row]
        vc.isFromFollow = p.UID
        self.show(vc, sender: self)
    }
    
}
