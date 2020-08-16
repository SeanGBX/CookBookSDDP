//
//  LoginViewController.swift
//  CookBook
//
//  Created by 180725J  on 7/12/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseUI
import GoogleSignIn




class LoginViewController: UIViewController {
    
    @IBOutlet var googleSignInBtn: GIDSignInButton!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKey")
        view.addGestureRecognizer(tap)
        
        //Google SignIn
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkUserInfo()
    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
   
    @IBAction func LoginTapped(_ sender: Any) {
        validateFields()
    }
    

    @IBAction func SignUpTapped(_ sender: Any) {
        //redirect to signup page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Register")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func validateFields(){
        //check if email field is empty
        if email.text?.isEmpty == true {
            print("Email Field is Empty!")
            return
        }
        //check if password field is empty
        if password.text?.isEmpty == true {
            print("Email Field is Empty!")
            return
        }
        
        login()
    }
    
    func login(){
        //Signs In User
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, err in
            guard let strongSelf = self else {return}
            if let err = err {
                print(err.localizedDescription)     
            }
            print(self!.email)
            print(self!.password)
            self!.checkUserInfo()
        }
    }
    
    func checkUserInfo() {
        if Auth.auth().currentUser != nil {
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let vc = storyboard.instantiateViewController(identifier: "mainHome")
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
    
    
}
