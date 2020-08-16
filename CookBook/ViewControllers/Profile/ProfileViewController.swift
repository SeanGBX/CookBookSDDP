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

class ProfileViewController: UIViewController {

    @IBOutlet weak var displayname: UILabel!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var postnum: UILabel!
    @IBOutlet weak var flwnum: UIButton!
    @IBOutlet weak var flwingnum: UIButton!
    
    @IBOutlet weak var flwbtn: UIButton!
    @IBOutlet weak var msgbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfile()
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
