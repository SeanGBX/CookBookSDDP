//
//  CreatePost1ViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/16/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseStorage

class CreatePost1ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var myPictureSwitch: UISwitch!
    @IBOutlet weak var createPostImage: UIImageView!
    @IBOutlet weak var createPostRecipeName: UITextField!
    @IBOutlet weak var createPostPicker: UIPickerView!
    @IBOutlet weak var progressToIngredientsButton: UIButton!
    
    var postItem: Posts?
    var newID: String?
    let username: String = "currentUser"
    
    var mealTypeData: [String] = [
        "Main Course",
        "Sauces & Sides",
        "Drinks",
        "Desserts",
        "Appetizers",
        "Snacks"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        myPictureSwitch.isOn = false
        progressToIngredientsButton.setTitleColor(UIColor.gray, for: .normal)
        progressToIngredientsButton.isEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        view.addGestureRecognizer(tap)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mealTypeData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mealTypeData[row]
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func progressToIngredients(_ sender: Any) {

        var error: String = ""
         
        if(createPostRecipeName.text == ""){
            error += "Recipe Name cannot be empty\n"
        }
        
        if(error != ""){
               let alert = UIAlertController(
                   title: error,
                   message: "",
                   preferredStyle: .alert
               )
                
               alert.addAction(
                   UIAlertAction(
                       title: "OK",
                       style: .default,
                       handler: nil)
               )
            
               self.present(alert, animated: true, completion: nil)
                
               return
        }
         
        postItem = Posts(recipeName: "", username: "", mealType: "", likes: 0, healthy: 0, tagBudget: "", tagStyle: "", tagPrep: "", postImage: "", postComplete: "0")
         
        postItem!.recipeName = createPostRecipeName.text!
        postItem!.username = self.username
         
        let pickerRow = createPostPicker.selectedRow(inComponent: 0)
        let selectedPickerText = mealTypeData[pickerRow]
        
        postItem!.mealType = selectedPickerText
        
        let randomID = UUID.init().uuidString
        let imagePath = "postImages/\(randomID).jpg"
        let uploadRef = Storage.storage().reference(withPath: imagePath)
        guard let imageData = createPostImage.image?.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetaData) {(downloadMetadata, error) in
            if let error = error {
                print ("error here \(error.localizedDescription)")
                return
            }
            print("upload Image complete: \(downloadMetadata)")
        }
        postItem!.postImage = imagePath
         
        let vc =
            storyboard?.instantiateViewController(identifier: "IngredientViewController") as! IngredientViewController
         
        postsDataManager.insertPost(newID ?? "", postItem!){
            postId in
            self.newID = postsDataManager.storePostID(postId)
            vc.postID = self.newID!
            self.show(vc, sender: self)
        }
    }
    
    @IBAction func myPictureSwitchChanged(_ sender: Any) {
        if (myPictureSwitch.isOn == false){
            progressToIngredientsButton.isEnabled = false
            progressToIngredientsButton.setTitleColor(UIColor.gray, for: .normal)
        }
        else{
            progressToIngredientsButton.isEnabled = true
            progressToIngredientsButton.setTitleColor(UIColor.purple, for: .normal)
        }
    }
    
    @IBAction func AddImageButton(_ sender: Any) {
        let alert1 = UIAlertController(
            title: "How would you like to add a picture?",
            message: "",
            preferredStyle: .alert
        )
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            alert1.addAction(
                UIAlertAction(
                    title: "Camera",
                    style: .default,
                    handler: {
                        action in
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.allowsEditing = true
                        
                        imagePicker.sourceType = .camera
                        self.present(imagePicker, animated: true)
                })
             )
        }
        
        alert1.addAction(
           UIAlertAction(
               title: "Library",
               style: .default,
               handler: {
                action in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
           })
        )
    
        self.present(alert1, animated: true, completion: nil)
        
        return
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage : UIImage = info[.editedImage] as! UIImage
        self.createPostImage!.image = chosenImage
        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil)
        
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
    
