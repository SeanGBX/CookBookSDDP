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
    @IBOutlet weak var displayimage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKey))
        view.addGestureRecognizer(tap)
        
        //bioText Styling
        bioText!.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        bioText!.layer.borderWidth = 1
        bioText!.layer.cornerRadius = 5
        displayimage.layer.borderWidth = 1
        displayimage.layer.masksToBounds = false
        displayimage.layer.borderColor = UIColor.black.cgColor
        displayimage.layer.cornerRadius = displayimage.frame.height/2
        displayimage.clipsToBounds = true
    }
    
    @objc func dismissKey() {
    view.endEditing(true)
    }
    
    
    @IBAction func SaveTapped(_ sender: Any) {
        var error = ""
        
        
        if displaynameText.text?.isEmpty == true {
            error += "Display Name cannot be empty!"
        }
        if bioText.text?.isEmpty == true {
            error += "Bio cannot be empty!"
        }
        if bioText.text.count > 50 {
            error += "Bio cannot have more than 50 characters!"
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
        }
        else {
            fillProfile()
        }

        
    }
    
    @IBAction func changePicBtn(_ sender: Any) {
         presentInputActionSheet()
    }
    func fillProfile() {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let email = user?.email
        let randomID = UUID.init().uuidString
        //create profile with new data
       let uploadRef = Storage.storage().reference(withPath: "profile/\(randomID).jpg")
       guard let imageData = displayimage.image?.jpegData(compressionQuality: 0.75) else{
           return
       }
       let uploadMetaData = StorageMetadata.init()
       uploadMetaData.contentType = "image/jpeg"
       uploadRef.putData(imageData, metadata: uploadMetaData){
           (downloadMetadata, error) in
           if let error = error {
               print("An error occured : \(error.localizedDescription)")
           }
           print(downloadMetadata)
           
           uploadRef.downloadURL(completion: {(url, error) in
               if let error = error{
                   print("An error occured : \(error.localizedDescription)")
                   return
               }
               if let url = url{
                   print(url.absoluteString)
                   let newpf = Profile(UID:uid!, email:email!, imageName: url.absoluteString, displayName:self.displaynameText.text!,bio:self.bioText.text!)
                          
                   profileDataManager.editProfile(newpf)
               }
           })
       }
        
        //redirect to home page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewController(identifier: "mainHome")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    private func presentInputActionSheet(){
                let actionSheet = UIAlertController()

                actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                    let picker = UIImagePickerController()
                    
                    picker.sourceType = .camera
                    picker.delegate = self
                    picker.allowsEditing = true
                    self?.present(picker, animated: true)
                }))
                actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.delegate = self
                    picker.allowsEditing = true
                    self?.present(picker, animated: true)
                }))
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                if !UIImagePickerController.isSourceTypeAvailable(.camera){
                    actionSheet.actions[0].isEnabled = false
                }
                present(actionSheet, animated: true)
             }
}
      


extension SetupProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        displayimage.image = image
        picker.dismiss(animated: true, completion: nil)
        
        
       
    }
}
