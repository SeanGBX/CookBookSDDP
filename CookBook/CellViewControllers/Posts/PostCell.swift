//
//  PostCell.swift
//  SDDPProject
//
//  Created by M07-3 on 6/13/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

protocol CustomCellUpdate: class {
    func updateTableView()
}

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var CLHLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var healthyButton: UIButton!
    
    weak var delegate: CustomCellUpdate?
    var postID: String?
    var postItem: Posts?
    var username: String = "currentUser"
    var likePostItem: LikePost?
    var healthyPostItem: HealthyPost?
    var likeList: [LikePost] = []
    var healthyList: [HealthyPost] = []
    var userLikes: [LikePost] = []
    var userHealthy: [HealthyPost] = []
    
    func loadCell() {
        loadLikes(id: postID!)
        loadHealthy(id: postID!)
        loadUserLikes(id: postID!)
        loadUserHealthy(id: postID!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadLikes(id: String){
        likePostDataManager.loadLikesByPost(id){
            likeList in
            self.likeList = likeList
        }
    }
    
    func loadHealthy(id: String){
        healthyPostDataManager.loadHealthyByPost(id){
            healthyList in
            self.healthyList = healthyList
        }
    }
    
    func loadUserLikes(id: String){
        likePostDataManager.loadUniqueLikes(id, username){
            uniqueLikeList in
            self.userLikes = uniqueLikeList
            if (self.userLikes.count > 0) {
                self.likeButton.setTitle("Unlike", for: .normal)
            }
        }
    }
    
    func loadUserHealthy(id: String){
        healthyPostDataManager.loadUniqueHealthy(id, username){
            uniqueHealthyList in
            self.userHealthy = uniqueHealthyList
            if (self.userHealthy.count > 0){
                self.healthyButton.setTitle("Unhealthy", for: .normal)
            }
        }
    }
    
    @IBAction func likeButtonClick(_ sender: Any) {
        likePostItem = LikePost(postId: postID!, username: username)
        if (userLikes.count == 0) {
            likeButton.setTitle("Unlike", for: .normal)
            likePostDataManager.insertLike(likePostItem!)
            postsDataManager.insertPostLike(postID!)
            delegate?.updateTableView()
        }
        
        else if (userLikes.count > 0) {
            likeButton.setTitle("Like", for: .normal)
            likePostDataManager.deleteLike(userLikes)
            postsDataManager.deletePostLike(postID!)
            delegate?.updateTableView()
        }
    }
    
    @IBAction func healthyButtonClick(_ sender: Any) {
        healthyPostItem = HealthyPost(postId: postID!, username: username)
        if (userHealthy.count == 0) {
            healthyButton.setTitle("Unhealthy", for: .normal)
            postsDataManager.insertPostHealthy(postID!)
            healthyPostDataManager.insertHealthy(healthyPostItem!)
            delegate?.updateTableView()
        }
        
        else if (userHealthy.count > 0){
            healthyButton.setTitle("Healthy", for: .normal)
            postsDataManager.deletePostHealthy(postID!)
            healthyPostDataManager.deleteHealthy(userHealthy)
            delegate?.updateTableView()
        }
    }
    
    @IBAction func deletePostButton(_ sender: Any) {
        if (postItem!.username == username){
            postsDataManager.deletePost(postID!)
        } else {
            print("You cannot delete someone elses post")
        }
    }
}
