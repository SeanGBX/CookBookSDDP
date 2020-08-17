//
//  OthersProfileViewController.swift
//  CookBook
//
//  Created by 180725J  on 8/14/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseAuth

class OthersProfileViewController: UIViewController {
    
    @IBOutlet weak var displayname: UILabel!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var postnum: UILabel!
    @IBOutlet weak var flwnum: UIButton!
    @IBOutlet weak var flwingnum: UIButton!
    
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var flwbtn: UIButton!
    @IBOutlet weak var msgbtn: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    var otherUser: Posts?
    
    var isFromFollow = ""
    
    var postList :[Posts] = []
    
    var currentUse = Auth.auth().currentUser?.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var uid = ""
        if isFromFollow != "" {
            uid = isFromFollow
        } else {
            let otheruid = otherUser!.username
            uid = otheruid
        }
        
        loadOthersProfile()
        followDataManager.deleteFollower(currentUse!, targetAccountUID: uid, onComplete: {
            unfollow in
            if (unfollow.count > 0){
                self.flwbtn.setTitle("Unfollow", for: .normal)
                self.flwbtn.setTitleColor(.systemRed, for: .normal)
            } else {
                self.flwbtn.setTitle("Follow", for: .normal)
                self.flwbtn.setTitleColor(self.view.tintColor, for: .normal)
            }
        })
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.register(PostCollectionViewCell.nib(), forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 128, height: 128)
        collectionView.collectionViewLayout = layout
        
        loadOthersProfile()
        loadUserPosts()
        
    }

    func loadOthersProfile() {
        //set displayname and bio
        var uid = ""
        if isFromFollow != "" {
            uid = isFromFollow
        } else {
            let otheruid = otherUser!.username
            uid = otheruid
        }
        profileDataManager.loadProfile(uid) { profiledb in
            self.displayname.text = profiledb[0].displayName
            self.bio.text = profiledb[0].bio
        }
        //set post num, flw num, flwing num
        profileDataManager.calculatePosts(uid) { posts in
            self.postnum.text = String(posts)
            print("TOTAL POST:",self.postnum.text)
            print("-------------------------")
        }
        profileDataManager.calculateFollowers(uid) { flw in
            self.flwnum.setTitle(String(flw), for: .normal)
            print("TOTAL FLW:",self.flwnum.titleLabel?.text)
        }
        profileDataManager.calculateFollowing(uid) { flwing in
            self.flwingnum.setTitle(String(flwing), for: .normal)
            print("-------------------------")
            print("TOTAL FLWING:",self.flwingnum.titleLabel?.text)
        }
    }
    
    func loadUserPosts() {
        var uid = ""
        if isFromFollow != "" {
            uid = isFromFollow
        } else {
            let otheruid = otherUser!.username
            uid = otheruid
        }

        //set postList
        profileDataManager.getUserPosts(uid) { posts in
            self.postList = posts
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func followTapped(_ sender: Any) {
        let currentUser = Auth.auth().currentUser
        let currentuid = currentUser?.uid
        
        var uid = ""
        if isFromFollow != "" {
            uid = isFromFollow
        } else {
            let otheruid = otherUser!.username
            uid = otheruid
        }
        
//        let newflw = Followers(followerAccountUID: currentuid!, targetAccountUID: otherUser!.username, followerID: "0")
//        followDataManager.insertFollower(newflw)
        
        followDataManager.deleteFollower(currentuid!, targetAccountUID: uid, onComplete: {
            unfollow in
            if (unfollow.count > 0){
                followDataManager.actuallyDeleteFollower(follower: unfollow)
                self.flwbtn.setTitle("Follow", for: .normal)
                var flwNumber  = Int((self.flwnum.titleLabel?.text)!)
                self.flwbtn.setTitleColor(self.view.tintColor, for: .normal)
                self.flwnum.setTitle(String(flwNumber! - 1), for: .normal)
            } else {
                var follower23 = Followers(followerAccountUID: currentuid!, targetAccountUID: uid, followerID: "0")
                followDataManager.insertFollower(follower23)
                self.flwbtn.setTitle("Unfollow", for: .normal)
                self.flwbtn.setTitleColor(.systemRed, for: .normal)
                var flwNumber  = Int((self.flwnum.titleLabel?.text)!)
                self.flwnum.setTitle(String(flwNumber! + 1), for: .normal)
            }
        })
        
    }
    
    
}

extension OthersProfileViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = UIStoryboard(name: "Posts", bundle: nil).instantiateViewController(identifier: "PostInfoViewController") as! PostInfoViewController
        let myIndexPath1 = self.collectionView.indexPathsForSelectedItems
        let myIndexPath = myIndexPath1![0]
        
        if(myIndexPath != nil){
            let post = postList[myIndexPath.row]
            vc.postItem = post
//            vc.isFromProfile = "1"
//            vc.isFromOtherProfile = otherUser!
            self.show(vc, sender: self)
        }
        print ("CVCell Tapped!")
    }
}

extension OthersProfileViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
        
        let p = postList[indexPath.row]
        let imageRef = Storage.storage().reference(withPath: p.postImage)
        imageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            if let data = data {
                cell.imageView.image = UIImage(data: data)
            }
        }
        
        return cell
    }
}

extension OthersProfileViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
}
