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
import Kommunicate

class ProfileViewController: UIViewController{
    

    @IBOutlet weak var displayname: UILabel!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var postnum: UILabel!
    @IBOutlet weak var flwnum: UIButton!
    @IBOutlet weak var flwingnum: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var flwbtn: UIButton!
    @IBOutlet weak var msgbtn: UIButton!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var postList :[Posts] = []
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionview initialisation and settings
        collectionView.register(PostCollectionViewCell.nib(), forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 , height: UIScreen.main.bounds.width/3)
        collectionView.collectionViewLayout = layout
        
        loadProfile()
        loadUserPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //collectionview initialisation and settings
        collectionView.register(PostCollectionViewCell.nib(), forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.size.width
        screenHeight = screenSize.size.height
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth/3 , height: screenWidth/3)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        
        //profile picture styling
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
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
            self.profileImage.kf.setImage(with: URL(string: profiledb[0].imageName), placeholder: UIImage(named: "defaultprofile"))
        }
        //set post num, flw num, flwing num
        profileDataManager.calculatePosts(uid!) { posts in
            self.postnum.text = String(posts)
            print("TOTAL POST:",self.postnum.text)
            print("-------------------------")
        }
        profileDataManager.calculateFollowers(uid!) { flw in
            self.flwnum.setTitle(String(flw), for: .normal)
            print("TOTAL FLW:",self.flwnum.titleLabel?.text)
        }
        profileDataManager.calculateFollowing(uid!) { flwing in
            self.flwingnum.setTitle(String(flwing), for: .normal)
            print("-------------------------")
            print("TOTAL FLWING:",self.flwingnum.titleLabel?.text)
            
        }
    }
    
    func loadUserPosts() {
        //get currentuser uid
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
        
        Kommunicate.logoutUser { (result) in
            switch result {
            case .success(_):
                print("Logout success")
            case .failure( _):
                print("Logout failure, now registering remote notifications(if not registered)")
                if !UIApplication.shared.isRegisteredForRemoteNotifications {
                    UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                        if granted {
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        }
                    }
                } else {
                }
            }
        }
        
        //redirect to login page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
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
        let vc = UIStoryboard(name: "Posts", bundle: nil).instantiateViewController(identifier: "PostInfoViewController") as! PostInfoViewController
        let myIndexPath1 = self.collectionView.indexPathsForSelectedItems
        let myIndexPath = myIndexPath1![0]
        
        if(myIndexPath != nil){
            let post = postList[myIndexPath.row]
            vc.postItem = post
            vc.isFromProfile = "1"
            self.show(vc, sender: self)
        }
        print ("CVCell Tapped!")
    }
}

extension ProfileViewController: UICollectionViewDataSource{
    
    //collectionview rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postList.count
    }
    
    //set cell data
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
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.borderWidth = 1.5
                cell.frame.size.width = self!.screenWidth/3
                cell.frame.size.height = self!.screenWidth/3
            }
        }
        
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    //collectionview styling
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3 , height: UIScreen.main.bounds.width/3)
    }
}
