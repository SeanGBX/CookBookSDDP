//
//  PostViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/13/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var postList: [Posts] = []
    var likeList: [LikePost] = []
    var healthyList: [HealthyPost] = []
    var userLikes: [LikePost] = []
    var userHealthy: [HealthyPost] = []
    let username: String = "currentUser"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadCompletePosts()
        
        self.navigationItem.setHidesBackButton(true, animated: true);
    }
    
    func loadCompletePosts(){
        postsDataManager.loadCompletePosts(){
            postListFromFirestore in
            self.postList = postListFromFirestore
            self.tableView.reloadData()
        }
    }
    
    func loadLikes(id: String){
        likePostDataManager.loadLikesByPost(id){
            likeList in
            self.likeList = likeList
            self.tableView.reloadData()
        }
    }
    
    func loadHealthy(id: String){
        healthyPostDataManager.loadHealthyByPost(id){
            healthyList in
            self.healthyList = healthyList
            self.tableView.reloadData()
        }
    }
    
    func loadUserLikes(id: String){
        likePostDataManager.loadUniqueLikes(id, username){
            uniqueLikeList in
            self.userLikes = uniqueLikeList
            self.tableView.reloadData()
        }
    }
    
    func loadUserHealthy(id: String){
        healthyPostDataManager.loadUniqueHealthy(id, username){
            uniqueHealthyList in
            self.userHealthy = uniqueHealthyList
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let p = postList[indexPath.row]
        loadLikes(id: p.postId)
        loadHealthy(id: p.postId)
        loadUserLikes(id: p.postId)
        loadUserHealthy(id: p.postId)
        cell.recipeName.text = p.recipeName
        cell.userName.text = p.username
        cell.CLHLabel.text = "10 comments, \(p.likes) likes, \(p.healthy) users find this healthy"
        cell.tagsLabel.text = "\(p.tagBudget), \(p.tagPrep), \(p.tagStyle)"
        cell.postImage.image = UIImage(named: p.postImage)
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ViewPostInfo"){
            let PostInfoViewController = segue.destination as! PostInfoViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            
            if(myIndexPath != nil){
                let post = postList[myIndexPath!.row]
                PostInfoViewController.postItem = post
            }
        }
    }
    
}
