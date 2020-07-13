//
//  IngredientInfoViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/16/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseStorage

class IngredientInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var ingredientInfoName: UITextField!
    @IBOutlet weak var ingredientInfoMeasureVal: UITextField!
    @IBOutlet weak var ingredientInfoMeasureType: UIPickerView!
    @IBOutlet weak var ingredientInfoImage: UIImageView!
    @IBOutlet weak var addEditIngredientButton: UIButton!
    @IBOutlet weak var stepInfo: UITextField!
    @IBOutlet weak var enableIngredientSwitch: UISwitch!
    @IBOutlet weak var enableIngredientLabel: UILabel!
    
    @IBOutlet weak var addIngredientImageButton: UIButton!
    
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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)

        enableIngredientSwitch.isOn = false

        ingredientInfoMeasureVal.isHidden = true
        ingredientInfoMeasureType.isHidden = true
        ingredientInfoName.isHidden = true
        ingredientInfoImage.isHidden = true
        addIngredientImageButton.isHidden = true
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
            
        
            print("--->\(segueIdentifier!)")
            if (segueIdentifier! == "EditIngredient"){
                enableIngredientSwitch.isEnabled = false
                enableIngredientSwitch.isHidden = true
                enableIngredientLabel.isHidden = true
                addIngredientImageButton.isHidden = true
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func isInteger(_ string: String) -> Bool {
        if (Int(string) != nil){
            return true
        } else {
            return false
        }
    }
    
    @IBAction func addEditIngredient(_ sender: Any) {
        var error = ""
        let measureValue = Int(ingredientInfoMeasureVal.text!)
        
        //do integer checking for measurevalue before image
        
        if (enableIngredientSwitch.isOn == true){
            
            if (ingredientInfoMeasureVal.text == "" || ingredientInfoMeasureVal.text == "0"){
                error += "Please enter a valid measurement value\n\n"
            }
            if (ingredientInfoName.text == ""){
                error += "Please enter an ingredient name\n\n"
            }
            if (isInteger(ingredientInfoMeasureVal.text!) == true){
                if (measureValue! <= 0){
                    error += "Please enter a valid measurement value\n\n"
                }
            } else {
                error += "Please enter a valid measurement value\n\n"
            }
            if (ingredientInfoImage.image == UIImage(named: "default")){
                error += "Please add an image for your ingredient\n\n"
            }
        }
        
        if (stepInfo.text == ""){
            error += "Please enter step information"
        }
        
        if(error != ""){
               let alert = UIAlertController(
                   title: "Problems with below fields",
                   message: error,
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
            ingredientItem!.ingredientImage = imagePath
            
        } else {
            ingredientItem!.ingredient = ""
            ingredientItem!.ingredientImage = "default"
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
        vc.loadIngredients()
        self.show(vc, sender: self)
    }
    
    
    @IBAction func deleteIngredient(_ sender: Any) {
        if (segueIdentifier! == "AddIngredient"){
            let vc = storyboard?.instantiateViewController(identifier: "IngredientViewController") as! IngredientViewController
            vc.postID = self.postID!
            self.show(vc, sender: self)
        }
        else{
            let vc = storyboard?.instantiateViewController(identifier: "IngredientViewController") as! IngredientViewController
            
            IngredientsDataManager.deleteIngredient( ingredientItem!.ingredientStepId)
            vc.postID = self.postID!
            self.show(vc, sender: self)
        }
    }
    
    @IBAction func enableIngredient(_ sender: Any) {
        if (enableIngredientSwitch.isOn == true){
            ingredientInfoMeasureVal.isHidden = false
            ingredientInfoMeasureType.isHidden = false
            ingredientInfoName.isHidden = false
            ingredientInfoImage.isHidden = false
            addIngredientImageButton.isHidden = false
        } else {
            ingredientInfoMeasureVal.isHidden = true
            ingredientInfoMeasureType.isHidden = true
            ingredientInfoName.isHidden = true
            ingredientInfoImage.isHidden = true
            addIngredientImageButton.isHidden = true
        }
    }
    
    
    @IBAction func addIngredientImage(_ sender: Any) {
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
               
               alert1.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
           
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
}
