//
//  PostCell.swift
//  SDDPProject
//
//  Created by M07-3 on 6/13/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol CustomCellLoadData: class {
    func loadCompletePosts()
}

protocol AlertShower: class {
    func showAlert(_ alert: PopupViewController)
}

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var CLHLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var healthyButton: UIButton!
    
    weak var delegate: CustomCellLoadData?
    weak var delegate1: AlertShower?
    var postID: String?
    var postItem: Posts?
    var username: String = Auth.auth().currentUser!.uid
    var likePostItem: LikePost?
    var healthyPostItem: HealthyPost?
    var likeList: [LikePost] = []
    var healthyList: [HealthyPost] = []
    var userLikes: [LikePost] = []
    var userHealthy: [HealthyPost] = []
    let alertService = AlertService()
    
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
                self.likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48"), for: .normal)
            }
        }
    }
    
    func loadUserHealthy(id: String){
        healthyPostDataManager.loadUniqueHealthy(id, username){
            uniqueHealthyList in
            self.userHealthy = uniqueHealthyList
            if (self.userHealthy.count > 0){
                self.healthyButton.setImage(#imageLiteral(resourceName: "icons8-kawaii-broccoli-50-2"), for: .normal)
            }
        }
    }
    
    @IBAction func likeButtonClick(_ sender: Any) {
        
        likePostItem = LikePost(postId: postID!, username: username)
        if (userLikes.count == 0) {
            likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48"), for: .normal)
            likePostDataManager.insertLike(likePostItem!)
            postsDataManager.insertPostLike(postID!){
                self.delegate?.loadCompletePosts()
            }
        }
        
        else if (userLikes.count > 0) {
            likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48-2"), for: .normal)
            likePostDataManager.deleteLike(userLikes)
            postsDataManager.deletePostLike(postID!){
                self.delegate?.loadCompletePosts()
            }
        }
    }
    
    @IBAction func healthyButtonClick(_ sender: Any) {
        healthyPostItem = HealthyPost(postId: postID!, username: username)
        if (userHealthy.count == 0) {
            healthyButton.setImage(#imageLiteral(resourceName: "icons8-kawaii-broccoli-50-2"), for: .normal)
            healthyPostDataManager.insertHealthy(healthyPostItem!)
            postsDataManager.insertPostHealthy(postID!){
                self.delegate?.loadCompletePosts()
            }
        }
        
        else if (userHealthy.count > 0){
            healthyButton.setImage(#imageLiteral(resourceName: "icons8-kawaii-broccoli-50"), for: .normal)
            healthyPostDataManager.deleteHealthy(userHealthy)
            postsDataManager.deletePostHealthy(postID!){
                self.delegate?.loadCompletePosts()
            }
        }
    }
    
    @IBAction func deletePostButton(_ sender: Any) {
        let alertVC = alertService.alert()
        delegate1?.showAlert(alertVC)

//        if (postItem!.username == username){
//            postsDataManager.deletePost(postID!)
//        } else {
//            print("You cannot delete someone elses post")
//        }
    }
}
