//
//  LoginViewController.swift
//  CookBook
//
//  Created by 180725J  on 7/12/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseUI




class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKey")
        view.addGestureRecognizer(tap)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkAutologin()
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
        var error = ""
        
        //check if email field is empty
        if email.text?.isEmpty == true {
            error += "Email field cannot be empty! \n"
        }

        //check if password field is empty
        if password.text?.isEmpty == true {
            error += "Password field cannot be empty! \n"
        }
        
        if error != ""{
            let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)

            
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: {
                action in

            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            login()
        }

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
        else {
            let alert = UIAlertController(title: "Login Error", message: "Email or Password is incorrect.", preferredStyle: .alert)

            
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: {
                action in

            }))
            self.present(alert, animated: true, completion: nil);            print("user not found or wrong password")
        }
    }
    
    //autologin function
    func checkAutologin() {
    if Auth.auth().currentUser != nil {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewController(identifier: "mainHome")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        }
    }
    
}
