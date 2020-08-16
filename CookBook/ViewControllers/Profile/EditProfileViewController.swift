//
//  EditProfileViewController.swift
//  CookBook
//
//  Created by 180725J  on 7/17/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseAuth

class EditProfileViewController: UIViewController {

    @IBOutlet weak var displayname: UITextField!
    @IBOutlet weak var bio: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKey")
        view.addGestureRecognizer(tap)
        
        //bioText Styling
        bio!.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        bio!.layer.borderWidth = 1
        bio!.layer.cornerRadius = 5
        
        loadProfile()
    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
    
    func loadProfile() {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        profileDataManager.loadProfile(uid!) { profiledb in
            self.displayname.text = profiledb[0].displayName
            self.bio.text = profiledb[0].bio
        }
    }
    @IBAction func cancelTapped(_ sender: Any) {
        //redirect to profile page
        let nav = self.navigationController
        nav?.popViewController(animated: true)
        
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        validateFields()
    }
    
    func validateFields(){
        //check if email field is empty
        if displayname.text?.isEmpty == true {
            print("displayname Field is Empty!")
            return
        }
        
        save()
    }
    
    func save(){
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let email = user?.email
        //create profile with new data
        let newpf = Profile(UID:uid!, email:email!, displayName:self.displayname.text!,bio:self.bio.text!)
        
        profileDataManager.editProfile(newpf)
        
        //redirect to profile page
        let vc = storyboard?.instantiateViewController(identifier:"Profile") as! ProfileViewController
        self.show(vc, sender: self)
        
    }
}
