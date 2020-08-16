//
//  IngredientInfoViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/16/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseStorage
import Foundation

class IngredientInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var ingredientInfoName: UITextField!
    @IBOutlet weak var ingredientInfoMeasureVal: UITextField!
    @IBOutlet weak var ingredientInfoMeasureType: UIPickerView!
    @IBOutlet weak var ingredientInfoImage: UIImageView!
    @IBOutlet weak var addEditIngredientButton: UIButton!
    @IBOutlet weak var stepInfo: UITextField!
    @IBOutlet weak var enableIngredientSwitch: UISwitch!
    @IBOutlet weak var enableIngredientLabel: UILabel!
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var addIngredientImageButton: UIButton!
    @IBOutlet weak var loadingBar: UIProgressView!
    
    var ingredientItem: IngredientSteps?
    var postID: String?
    var segueIdentifier: String?
    var ingredientIndex: Int?
    var ingredientID: String?
    
    var measurementTypeData : [String] = [
        "ml",
        "l",
        "kg",
        "g",
        "mg",
        "lbs",
        "cup",
        "tbsp",
        "tsp",
        "oz",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKey")
        
        view.addGestureRecognizer(tap)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        enableIngredientSwitch.isOn = false
        loadingBar.isHidden = true
        ingredientInfoMeasureVal.isHidden = true
        ingredientInfoMeasureType.isHidden = true
        ingredientInfoName.isHidden = true
        ingredientInfoImage.isHidden = true
        addIngredientImageButton.isHidden = true
        ingredientNameLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ingredientItem != nil {
            let imageRef = Storage.storage().reference(withPath: ingredientItem!.ingredientImage)
            imageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                if let data = data {
                    self!.ingredientInfoImage.image = UIImage(data: data)
                } else {
                    self!.ingredientInfoImage.image = UIImage(named: "default")
                }
            }
            ingredientInfoName.text = ingredientItem!.ingredient
            ingredientInfoMeasureVal.text = "\(ingredientItem!.measureVal)"
            stepInfo.text = ingredientItem!.step
            let indexOfMeasureType:Int = measurementTypeData.firstIndex(of: ingredientItem!.measureType) ?? 0
            
            ingredientInfoMeasureType.selectRow(indexOfMeasureType ?? 0, inComponent: 0, animated: true)
            
            if (segueIdentifier! == "EditIngredient"){
                enableIngredientSwitch.isEnabled = false
                enableIngredientSwitch.isHidden = true
                enableIngredientLabel.isHidden = true
                ingredientInfoImage.isHidden = true
                if (ingredientItem!.ingredient != "") {
                    enableIngredientSwitch.isOn = true
                    
                    ingredientInfoMeasureVal.isHidden = false
                    ingredientInfoMeasureType.isHidden = false
                    ingredientInfoName.isHidden = false
                    ingredientInfoImage.isHidden = false
                    addIngredientImageButton.isHidden = false
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return measurementTypeData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return measurementTypeData[row]
    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
    
    func isInteger() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: ingredientInfoMeasureVal.text!))
    }
    
    func areEqualImages() -> Bool {
        let image1 = #imageLiteral(resourceName: "Default").pngData()
        let image2 = ingredientInfoImage.image?.pngData()
        if image1 == image2{
            return true
        } else {
            return false
        }
    }
    
    @IBAction func addEditIngredient(_ sender: Any) {
        var error1 = ""
        let measureValue = Int(ingredientInfoMeasureVal.text!)
        
        //do integer checking for measurevalue before image
        
        if (enableIngredientSwitch.isOn == true){
            
            if (ingredientInfoName.text == ""){
                error1 += "Please enter an ingredient name\n\n"
            }
            if (isInteger() == true){
                if (measureValue! <= 0){
                    error1 += "Please enter a measurement value above 0\n\n"
                }
            } else {
                error1 += "Please enter a valid measurement value\n\n"
            }

            if (areEqualImages() == true){
                error1 += "Please add an image for your ingredient\n\n"
            }
        }
        
        if (stepInfo.text == ""){
            error1 += "Please enter step information"
        }
        
        if(error1 != ""){
               let alert4 = UIAlertController(
                   title: error1,
                   message: "",
                   preferredStyle: .alert
               )
                
               alert4.addAction(
                   UIAlertAction(
                       title: "OK",
                       style: .default,
                       handler: nil)
               )
            
               self.present(alert4, animated: true, completion: nil)
                
               return
        }
        
        let vc = storyboard?.instantiateViewController(identifier: "IngredientViewController") as! IngredientViewController
        
        if (enableIngredientSwitch.isOn == true){
            ingredientItem!.ingredient = ingredientInfoName.text!
            ingredientItem!.measureVal = measureValue != nil ? measureValue! : 0
            
            let pickerRow = ingredientInfoMeasureType.selectedRow(inComponent: 0)
            let selectedPickerText = measurementTypeData[pickerRow]
            ingredientItem!.measureType = selectedPickerText
            let randomID = UUID.init().uuidString
            let imagePath = "ingredientImages/\(randomID).jpg"
            let uploadRef = Storage.storage().reference(withPath: imagePath)
            guard let imageData = ingredientInfoImage.image?.jpegData(compressionQuality: 0.5) else {return}
            let uploadMetaData = StorageMetadata.init()
            uploadMetaData.contentType = "image/jpeg"
            uploadRef.putData(imageData, metadata: uploadMetaData) {(downloadMetadata, error) in
                if let error = error {
                    print ("error here \(error.localizedDescription)")
                    return
                }
                print("upload Image complete: \(downloadMetadata)")
            }
            self.ingredientItem!.ingredientImage = imagePath
        } else {
            ingredientItem!.ingredient = ""
            ingredientItem!.measureVal = 0
            ingredientItem!.measureType = "ml"
        }
        
        ingredientItem!.step = stepInfo.text!
        ingredientItem!.postId = postID!
        
        if (segueIdentifier! == "AddIngredient"){
            IngredientsDataManager.insertIngredient(ingredientItem!)
        }
        else{
            IngredientsDataManager.editIngredient(ingredientItem!)
        }
        
        vc.postID = self.postID!
        addEditIngredientButton.isEnabled = false
        
        loadingBar.isHidden = false
        loadingBar.setProgress(3, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            vc.loadIngredients()
            self.show(vc, sender: self)
        })
    }
    
    
    @IBAction func deleteIngredient(_ sender: Any) {
        if (segueIdentifier! == "AddIngredient"){
            let vc = storyboard?.instantiateViewController(identifier: "IngredientViewController") as! IngredientViewController
            
               let alert3 = UIAlertController(
                   title: "Are you sure you want to delete this ingredient?",
                   message: "",
                   preferredStyle: .alert
               )
                
                alert3.addAction(
                    UIAlertAction(
                        title: "Cancel",
                        style: .destructive,
                        handler: nil)
                )
                
               alert3.addAction(
                   UIAlertAction(
                       title: "OK",
                       style: .default,
                       handler: { handler in
                        vc.postID = self.postID!
                        self.show(vc, sender: self)
                    })
               )
                
            
               self.present(alert3, animated: true, completion: nil)
                
               return
        }
        else{
            let vc = storyboard?.instantiateViewController(identifier: "IngredientViewController") as! IngredientViewController
            
           let alert = UIAlertController(
               title: "Are you sure you want to delete this ingredient?",
               message: "",
               preferredStyle: .alert
           )
            
            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .destructive,
                    handler: nil)
            )
            
           alert.addAction(
               UIAlertAction(
                   title: "OK",
                   style: .default,
                   handler: { handler in
                    IngredientsDataManager.deleteIngredient( self.ingredientItem!.ingredientStepId)
                    vc.postID = self.postID!
                    self.show(vc, sender: self)
                })
           )
            
        
           self.present(alert, animated: true, completion: nil)
            
           return
            
            
        }
    }
    
    @IBAction func enableIngredient(_ sender: Any) {
        if (enableIngredientSwitch.isOn == true){
            ingredientInfoMeasureVal.isHidden = false
            ingredientInfoMeasureType.isHidden = false
            ingredientInfoName.isHidden = false
            ingredientInfoImage.isHidden = false
            addIngredientImageButton.isHidden = false
            ingredientNameLabel.isHidden = false
        } else {
            ingredientInfoMeasureVal.isHidden = true
            ingredientInfoMeasureType.isHidden = true
            ingredientInfoName.isHidden = true
            ingredientInfoImage.isHidden = true
            addIngredientImageButton.isHidden = true
            ingredientNameLabel.isHidden = true
        }
    }
    
    
    @IBAction func addIngredientImage(_ sender: Any) {
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
        self.ingredientInfoImage!.image = chosenImage
        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil)
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "IngredientViewController") as! IngredientViewController
        vc.postID = self.postID
        self.show(vc, sender: self)
    }
}
