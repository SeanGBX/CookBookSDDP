//
//  PostCell.swift
//  SDDPProject
//
//  Created by M07-3 on 6/13/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

protocol CustomCellLoadData: class {
    func loadRecommend()
//    func loadCompletePosts()
    func loadCompletePostsByHealthy()
    func loadFollowerPosts()
    func showAlert(_ id: String, _ username: String, _ postId: String)
    func getSegmentIndex() -> Int
    func moveToComments(postItem: Posts)
    func moveToProfile(pos: Posts)
}

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var CLHLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var healthyButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var comment1Text: UILabel!
    @IBOutlet weak var comment2Text: UILabel!
    @IBOutlet weak var goToProfileButton: UIButton!
    
    weak var delegate: CustomCellLoadData?
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
        userImage.layer.cornerRadius =  userImage.frame.size.width / 2
        userImage.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        self.likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48-2"), for: .normal)
        self.healthyButton.setImage(#imageLiteral(resourceName: "icons8-kawaii-broccoli-50"), for: .normal)
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
            if id == self.postID!{
                self.userLikes = uniqueLikeList
                if (self.userLikes.count > 0) {
                    self.likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48"), for: .normal)
                }
            }
        }
    }
    
    func loadUserHealthy(id: String){
        healthyPostDataManager.loadUniqueHealthy(id, username){
            uniqueHealthyList in
            if id == self.postID!{
                self.userHealthy = uniqueHealthyList
                if (self.userHealthy.count > 0){
                    self.healthyButton.setImage(#imageLiteral(resourceName: "icons8-kawaii-broccoli-50-2"), for: .normal)
                }
            }
        }
    }
    
    @IBAction func likeButtonClick(_ sender: Any) {
        let vc = UIStoryboard(name: "Posts", bundle: .main).instantiateViewController(identifier: "PostViewController") as! PostViewController
        likePostItem = LikePost(postId: postID!, username: username, budget: postItem!.tagBudget, prepTime: postItem!.tagPrep, cookStyle: postItem!.tagStyle)
        if (userLikes.count == 0) {
            print("-.-\(userLikes.count)")
            print(username)
            likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48"), for: .normal)
            likePostDataManager.insertLike(likePostItem!)
            postsDataManager.insertPostLike(postID!){
                let index = self.delegate?.getSegmentIndex()
                if (index! == 0){
                    self.delegate?.loadRecommend()
                } else if (index! == 1){
                    self.delegate?.loadFollowerPosts()
                } else if (index! == 2) {
                    self.delegate?.loadCompletePostsByHealthy()
                }
            }
        }
        
        else if (userLikes.count > 0) {
            likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48-2"), for: .normal)
            likePostDataManager.deleteLike(userLikes)
            postsDataManager.deletePostLike(postID!){
                let index = self.delegate?.getSegmentIndex()
                if (index! == 0){
                    self.delegate?.loadRecommend()
                } else if (index! == 1){
                    self.delegate?.loadFollowerPosts()
                } else if (index! == 2) {
                    self.delegate?.loadCompletePostsByHealthy()
                }
            }
        }
    }
    
    @IBAction func healthyButtonClick(_ sender: Any) {
        healthyPostItem = HealthyPost(postId: postID!, username: username)
        if (userHealthy.count == 0) {
            healthyButton.setImage(#imageLiteral(resourceName: "icons8-kawaii-broccoli-50-2"), for: .normal)
            healthyPostDataManager.insertHealthy(healthyPostItem!)
            postsDataManager.insertPostHealthy(postID!){
                let index = self.delegate?.getSegmentIndex()
                if (index! == 0){
                    self.delegate?.loadRecommend()
                } else if (index! == 1){
                    self.delegate?.loadFollowerPosts()
                } else if (index! == 2) {
                    self.delegate?.loadCompletePostsByHealthy()
                }
            }
        }
        
        else if (userHealthy.count > 0){
            healthyButton.setImage(#imageLiteral(resourceName: "icons8-kawaii-broccoli-50"), for: .normal)
            healthyPostDataManager.deleteHealthy(userHealthy)
            postsDataManager.deletePostHealthy(postID!){
                let index = self.delegate?.getSegmentIndex()
                if (index! == 0){
                    self.delegate?.loadRecommend()
                } else if (index! == 1){
                    self.delegate?.loadFollowerPosts()
                } else if (index! == 2) {
                    self.delegate?.loadCompletePostsByHealthy()
                }
            }
        }
    }
    
    @IBAction func deletePostButton(_ sender: Any) {
        delegate?.showAlert(postID!, postItem!.username, postItem!.postId)
    }
    
    
    @IBAction func commentButtonClick(_ sender: Any) {
        delegate?.moveToComments(postItem: postItem!)
    }
    
    
    @IBAction func goToProfileButtonClick(_ sender: Any) {
        delegate?.moveToProfile(pos: postItem!)
    }
    
}
