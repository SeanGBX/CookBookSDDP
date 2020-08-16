//
//  SetupProfileViewController.swift
//  CookBook
//
//  Created by 180725J  on 7/16/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseUI

class SetupProfileViewController: UIViewController {

    @IBOutlet weak var displaynameText: UITextField!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var displaynameError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //bioText Styling
        bioText!.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        bioText!.layer.borderWidth = 1
        bioText!.layer.cornerRadius = 5
    }
    
    @objc func dismissKeyboard() {
    view.endEditing(true)
    }
    
    
    @IBAction func SaveTapped(_ sender: Any) {
        //check if displayname field is empty
        if displaynameText.text?.isEmpty == true {
            displaynameError.isHidden = false
            print("ERR:",displaynameError)
            print("displayname field is empty!")
            return
        }
        fillProfile()
        
    }
    
    func fillProfile() {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let email = user?.email
        
        //create profile with new data
        let newpf = Profile(UID:uid!, email:email!, displayName:displaynameText.text!,bio:bioText.text!)
        
        profileDataManager.editProfile(newpf)
        
        //redirect to home page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewController(identifier: "mainHome")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}
