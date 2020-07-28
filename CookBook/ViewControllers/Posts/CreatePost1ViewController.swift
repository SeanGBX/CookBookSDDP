//
//  CreatePost1ViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/16/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class CreatePost1ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var myPictureSwitch: UISwitch!
    @IBOutlet weak var createPostImage: UIImageView!
    @IBOutlet weak var createPostRecipeName: UITextField!
    @IBOutlet weak var createPostPicker: UIPickerView!
    @IBOutlet weak var progressToIngredientsButton: UIButton!
    
    var postItem: Posts?
    var newID: String?
    let username: String = Auth.auth().currentUser!.uid
    var selectedPost: [Posts] = []
    
    var mealTypeData: [String] = [
        "Main Course",
        "Sauces & Sides",
        "Drinks",
        "Desserts",
        "Appetizers",
        "Brunch"
    ]
    
    func loadSpecificPost(id: String){
        postsDataManager.loadSpecificPost(id){
            post in
            print("-.-!\(id)")
            for i in post{
                self.postItem = i
            }
            let indexOfMeasureType:Int = self.mealTypeData.firstIndex(of: self.postItem!.mealType) ?? 0
            
            self.createPostPicker.selectRow(indexOfMeasureType ?? 0, inComponent: 0, animated: true)
            self.createPostRecipeName.text = self.postItem!.recipeName
            let imageRef = Storage.storage().reference(withPath: self.postItem!.postImage)
            imageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                if let data = data {
                    self!.createPostImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    func postExists(id: String){
        postsDataManager.loadSpecificPost(id){
            post in
            self.selectedPost = post
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        myPictureSwitch.isOn = false
        progressToIngredientsButton.setTitleColor(UIColor.gray, for: .normal)
        
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
    
    func areEqualImages() -> Bool {
        let image1 = #imageLiteral(resourceName: "Default").pngData()
        let image2 = createPostImage.image?.pngData()
        if image1 == image2{
            return true
        } else {
            return false
        }
    }
    
    @IBAction func progressToIngredients(_ sender: Any) {
        if (myPictureSwitch.isOn == true ){
            var error: String = ""
                
            if(createPostRecipeName.text == ""){
               error += "Recipe Name cannot be empty\n\n"
            }
            
            if(areEqualImages() == true){
                error += "Please add a picture of your recipe"
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
            postItem!.username = username
            
           let pickerRow = createPostPicker.selectedRow(inComponent: 0)
           let selectedPickerText = mealTypeData[pickerRow]
               
           postItem!.mealType = selectedPickerText
           
           let randomID = UUID.init().uuidString
           let imagePath = "postImages/\(randomID).jpg"
           let uploadRef = Storage.storage().reference(withPath: imagePath)
           guard let imageData = createPostImage.image?.jpegData(compressionQuality: 0.5) else {return}
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
            
            if (selectedPost.count == 0){
                postsDataManager.insertPost(postItem!){
                    postId in
                    self.newID = postsDataManager.storePostID(postId)
                    vc.postID = self.newID!
                    self.show(vc, sender: self)
                }
            } else {
                print("-.-\(self.newID!)")
                postsDataManager.editPost(self.newID!, postItem!){
                    postId in
                    self.newID = postsDataManager.storePostID(postId)
                    vc.postID = self.newID!
                    self.show(vc, sender: self)
                }
            }
            
        } else {
           let alertMyPic = UIAlertController(
               title: "Please switch on the 'This is my picture' switch",
               message: "",
               preferredStyle: .alert
           )
            
           alertMyPic.addAction(
               UIAlertAction(
                   title: "OK",
                   style: .default,
                   handler: nil)
           )
        
           self.present(alertMyPic, animated: true, completion: nil)
            
           return
        }
    }
    
    @IBAction func AddImageButton(_ sender: Any) {
        let alert1 = UIAlertController(
            title: "How would you like to add a picture?",
            message: "",
            preferredStyle: .alert
        )
        
        alert1.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
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
    
    
    @IBAction func myPicSwitchClick(_ sender: Any) {
        if (myPictureSwitch.isOn == true){
            progressToIngredientsButton.setTitleColor(UIColor.systemIndigo, for: .normal)
        } else {
            progressToIngredientsButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
        self.show(vc, sender: self)
    }
}
    
