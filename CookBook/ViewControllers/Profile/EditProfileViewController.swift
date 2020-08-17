//
//  EditProfileViewController.swift
//  CookBook
//
//  Created by 180725J  on 7/17/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class EditProfileViewController: UIViewController {

    @IBOutlet weak var displayname: UITextField!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var displayimage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss keyboard function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKey")
        view.addGestureRecognizer(tap)
        
        //bioText Styling
        bio!.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        bio!.layer.borderWidth = 1
        bio!.layer.cornerRadius = 5
        displayimage.layer.borderWidth = 1
        displayimage.layer.masksToBounds = false
        displayimage.layer.borderColor = UIColor.black.cgColor
        displayimage.layer.cornerRadius = displayimage.frame.height/2
        displayimage.clipsToBounds = true
        loadProfile()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        let vc = storyboard?.instantiateViewController(identifier:"Profile") as! ProfileViewController
//        vc.loadProfile()
//    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
   
    
    func loadProfile() {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        profileDataManager.loadProfile(uid!) { profiledb in
            self.displayname.text = profiledb[0].displayName
            self.bio.text = profiledb[0].bio
            self.displayimage.kf.setImage(with: URL(string: profiledb[0].imageName), placeholder: UIImage(named: "defaultprofile"))
        }
    }
    
    @IBAction func changePicBtn(_ sender: Any) {
        presentInputActionSheet()
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
        var error = ""
        
        
        if displayname.text?.isEmpty == true {
            error += "Display Name cannot be empty!"
        }
         if bio.text?.isEmpty == true {
                   error += "Bio cannot be empty!"
               }
        if bio.text.count > 50 {
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
        } else {
            save()
        }
        
    }
    
    func save(){
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let email = user?.email
        //create profile with new data
       
        
        let randomID = UUID.init().uuidString
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
                    let newpf = Profile(UID:uid!, email:email!, imageName: url.absoluteString, displayName:self.displayname.text!,bio:self.bio.text!)
                           
                    profileDataManager.editProfile(newpf)
                }
            })
        }
        
        //redirect to profile page
        let vc = storyboard?.instantiateViewController(identifier:"Profile") as! ProfileViewController
        vc.loadProfile()
        self.show(vc, sender: self)

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


extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        displayimage.image = image
        picker.dismiss(animated: true, completion: nil)
        
        
       
    }
}
