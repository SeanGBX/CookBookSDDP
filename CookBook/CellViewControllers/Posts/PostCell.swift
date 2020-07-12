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
    var username: String = "currentUser"
    var likePostItem: LikePost?
    var healthyPostItem: HealthyPost?
    var likeList: [LikePost] = []
    var healthyList: [HealthyPost] = []
    var userLikes: [LikePost] = []
    var userHealthy: [HealthyPost] = []
    
    
    func loadCell() {
        print("uuuu\(postID!)")
        loadLikes(id: postID!)
        loadHealthy(id: postID!)
        loadUserLikes(id: postID!)
        loadUserHealthy(id: postID!)
        if (userLikes != []) {
            likeButton.setTitle("Unlike", for: .normal)
        }
        if (userHealthy != []){
            healthyButton.setTitle("Unhealthy", for: .normal)
        }
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
        }
    }
    
    func loadUserHealthy(id: String){
        healthyPostDataManager.loadUniqueHealthy(id, username){
            uniqueHealthyList in
            self.userHealthy = uniqueHealthyList
        }
    }
    
    @IBAction func likeButtonClick(_ sender: Any) {
        likePostItem = LikePost(postId: postID!, username: username)
        print(userLikes)
        if (userLikes.count == 0) {
            likePostDataManager.insertLike(likePostItem!)
            delegate?.updateTableView()
        } else {
            likePostDataManager.deleteLike(userLikes)
            delegate?.updateTableView()
        }
    }
    
    @IBAction func healthyButtonClick(_ sender: Any) {
        healthyPostItem = HealthyPost(postId: postID!, username: username)
        if (userHealthy.count == 0) {
            healthyPostDataManager.insertHealthy(healthyPostItem!)
            delegate?.updateTableView()
        } else {
            healthyPostDataManager.deleteHealthy(userHealthy)
            delegate?.updateTableView()
        }
    }
    
    
}
