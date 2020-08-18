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

class FollowingViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CustomCellLoadDataProfile{
        
    @IBOutlet weak var tableViewFollowing: UITableView!
    
    var followingList :[Followers] = []
    var profileList :[Profile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllFollowing()
    }
    
    //reload tableview
    func loadData() {
        self.tableViewFollowing.reloadData()
    }
    
    //load followings of UID
    func loadAllFollowing() {
        let currentUser = Auth.auth().currentUser
        let currentuid = currentUser?.uid
        
        followDataManager.loadFollowing(currentuid!) {
            flwingdb in
            self.followingList = flwingdb
            
             for i in self.followingList {
                profileDataManager.loadProfile(i.targetAccountUID){
                profiledb in
                    self.profileList.append(profiledb[0])
                    self.tableViewFollowing.reloadData()
                }
            }
        }
    }
    
   //tableView rows
    func tableView(_ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int
    {
        return profileList.count
    }
    
    //set cell data
    func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: ProfileCellA = tableView.dequeueReusableCell(withIdentifier: "ProfileCellA", for: indexPath) as! ProfileCellA
        
        let p = profileList[indexPath.row]
        cell.NameLabel?.text = p.displayName
        cell.followerAccountUID = p.UID
        cell.ImageView.kf.setImage(with: URL(string: p.imageName), placeholder: UIImage(named: "defaultprofile"))
        cell.delegate = self

        return cell
        
    }
    
    //cell onselect go to profile page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "OthersProfile") as! OthersProfileViewController
        let p = profileList[indexPath.row]
        vc.isFromFollow = p.UID
        self.show(vc, sender: self)
    }
    
}
