//
//  CreatePost1ViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/16/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class CreatePost1ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var myPictureSwitch: UISwitch!
    @IBOutlet weak var createPostImage: UIImageView!
    @IBOutlet weak var createPostRecipeName: UITextField!
    @IBOutlet weak var createPostPicker: UIPickerView!
    
    var postItems: Posts?
    var newID: String?
    
    var mealTypeData: [String] = [
        "Breakfast",
        "Lunch",
        "Dinner",
        "Snack",
        "Other"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        myPictureSwitch.isOn = false
        
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

        var error1: String = ""
         
        if(createPostRecipeName.text == ""){
            error1 += "Recipe Name cannot be empty\n"
             
            let alert = UIAlertController(
                title: error1,
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
         
        postItems = Posts(recipeName: "", username: "", mealType: "", likes: 0, healthy: 0, tagBudget: "", tagStyle: "", tagPrep: "", postImage: "")
         
        postItems!.recipeName = createPostRecipeName.text!
         
        let pickerRow = createPostPicker.selectedRow(inComponent: 0)
        let selectedPickerText = mealTypeData[pickerRow]
        postItems!.mealType = selectedPickerText
         
        let vc =
            storyboard?.instantiateViewController(identifier: "IngredientViewController") as! IngredientViewController
         
        postsDataManager.insertPost(postItems!){
            postId in
            self.newID = postsDataManager.storePostID(postId)
            vc.postID = self.newID!
            self.show(vc, sender: self)
        }
    }
}
    