//
//  ProfileViewController.swift
//  CookBook
//
//  Created by 180725J  on 7/13/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseAuth

class ProfileViewController: UIViewController{
    

    @IBOutlet weak var displayname: UILabel!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var postnum: UILabel!
    @IBOutlet weak var flwnum: UIButton!
    @IBOutlet weak var flwingnum: UIButton!
    
    @IBOutlet weak var flwbtn: UIButton!
    @IBOutlet weak var msgbtn: UIButton!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var postList :[Posts] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(PostCollectionViewCell.nib(), forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 128, height: 128)
        collectionView.collectionViewLayout = layout
        
        loadProfile()
        loadUserPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.register(PostCollectionViewCell.nib(), forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 128, height: 128)
        collectionView.collectionViewLayout = layout
        
        loadProfile()
        loadUserPosts()
        
    }
    
    
    func loadProfile() {
        //set displayname and bio
        let user = Auth.auth().currentUser
        let uid = user?.uid
        profileDataManager.loadProfile(uid!) { profiledb in
            self.displayname.text = profiledb[0].displayName
            self.bio.text = profiledb[0].bio
        }
        //set post num 
        profileDataManager.calculatePosts(uid!) { posts in
            self.postnum.text = String(posts)
            print("TOTAL POST:",self.postnum.text)
        }
    }
    
    func loadUserPosts() {
        let user = Auth.auth().currentUser
        let uid = user?.uid

        //set postList
        profileDataManager.getUserPosts(uid!) { posts in
            self.postList = posts
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        //signout user
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError{
            print("Error signing out: %@", signOutError)
        }
        
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let email = user?.email
        print("current user:",user,"UID:",uid,"email:",email)
        
        //redirect to login page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }

    @IBAction func otherProfileTapped(_ sender: Any) {
        //redirect to edit profile page
            let vc = storyboard?.instantiateViewController(identifier:"OthersProfile") as! OthersProfileViewController
            self.show(vc, sender: self)
    }
    
    @IBAction func editProfileTapped(_ sender: Any) {
        //redirect to edit profile page
        let vc = storyboard?.instantiateViewController(identifier:"EditProfile") as! EditProfileViewController
        self.show(vc, sender: self)
    }
    
    @IBAction func followerTapped(_ sender: Any) {
        //redirect to followers page
        let vc = storyboard?.instantiateViewController(identifier:"Followers") as! FollowersViewController
        self.show(vc, sender: self)
    }
    
    @IBAction func followingTapped(_ sender: Any) {
         //redirect to edit profile page
        let vc = storyboard?.instantiateViewController(identifier:"Following") as! FollowingViewController
        self.show(vc, sender: self)
    }
}

extension ProfileViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        print ("CVCell Tapped!")
    }
}

extension ProfileViewController: UICollectionViewDataSource{
    
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

extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
}
