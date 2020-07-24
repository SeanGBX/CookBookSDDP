//
//  RegisterViewController.swift
//  CookBook
//
//  Created by 180725J  on 7/12/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmpassword: UITextField!
    @IBOutlet weak var displayname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func LoginTapped(_ sender: Any) {
        //redirect to login page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        //check if email field is empty
        if email.text?.isEmpty == true {
            print("email field is empty!")
            return
        }
        //check if password field is empty
        if password.text?.isEmpty == true {
            print("password field is empty!")
            return
        }
        signUP()
    }
    
    func signUP() {
        //create user account
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            guard let user = authResult?.user, error == nil else{
                print("Error \(error?.localizedDescription)")
                return
            }
            //after account creation is complete
            self.postSignUP()
        }
        //redirect to profile setup page
        let storyboard = UIStoryboard(name: "Profile",     bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "setupProfile")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func postSignUP() {
        //print new user info
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let email = user?.email
        print("current user:",user,"UID:",uid,"email:",email)
        
        //create profile object for new user
        let pf = Profile(UID:uid!, email:email!, displayName: "",bio: "")
        profileDataManager.insertProfile(pf)
    }
}
