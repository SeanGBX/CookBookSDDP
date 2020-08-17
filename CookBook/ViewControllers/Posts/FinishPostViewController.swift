//
//  FinishPostViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/17/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseStorage

class FinishPostViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var finalImage: UIImageView!
    @IBOutlet weak var finalName: UILabel!
    @IBOutlet weak var budgetTF: UITextField!
    @IBOutlet weak var cookingStyleTF: UITextField!
    @IBOutlet weak var prepTimeTF: UITextField!
    
    var postID: String?
    var postItem: Posts?
    var selectedPost: [Posts] = []
    var ingredientList: [IngredientSteps]?
    
    var budgetData : [String] = ["Cheap","Moderately-Priced","Expensive"]
    var cookStyleData : [String] = ["Asian", "Western", "Mexican", "Middle-Eastern", "European", "African"]
    var prepTimeData : [String] = ["Quick", "Moderate", "Long"]
    
    var budgetPick = UIPickerView()
    var cookingStylePick = UIPickerView()
    var prepTimePick = UIPickerView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true);
        loadSpecificPost()
        budgetTF.inputView = budgetPick
        cookingStyleTF.inputView = cookingStylePick
        prepTimeTF.inputView = prepTimePick
        
        budgetPick.delegate = self
        budgetPick.dataSource = self
        cookingStylePick.delegate = self
        cookingStylePick.dataSource = self
        prepTimePick.delegate = self
        prepTimePick.dataSource = self
        
        budgetPick.tag = 1
        cookingStylePick.tag = 2
        prepTimePick.tag = 3
        
        budgetTF.text = budgetData[0]
        cookingStyleTF.text = cookStyleData[0]
        prepTimeTF.text = prepTimeData[0]
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKey")
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
    
    func loadSpecificPost(){
        postsDataManager.loadSpecificPost(self.postID!){
            postFromFirestore in
            self.selectedPost = postFromFirestore
            for i in self.selectedPost{
                let imageRef = Storage.storage().reference(withPath: i.postImage)
                imageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                        return
                    }
                    if let data = data {
                        self?.finalImage.image = UIImage(data: data)
                    }
                }
                self.finalName.text = i.recipeName
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return budgetData.count
            
        case 2:
            return cookStyleData.count
            
        case 3:
            return prepTimeData.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return budgetData[row]
        case 2:
            return cookStyleData[row]
        case 3:
            return prepTimeData[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            budgetTF.text = budgetData[row]
            self.view.endEditing(true)
        case 2:
            cookingStyleTF.text = cookStyleData[row]
            self.view.endEditing(true)
        case 3:
            prepTimeTF.text = prepTimeData[row]
            self.view.endEditing(true)
        default:
            self.view.endEditing(true)
        }
    }
    
    
    @IBAction func postRecipeButton(_ sender: Any) {
        var error = ""
        
        if (!budgetData.contains(budgetTF.text ?? "")){
            error += "Please select a valid budget \n\n"
        }
        
        if (!cookStyleData.contains(cookingStyleTF.text ?? "")){
            error += "Please select a valid Cooking Style \n\n"
        }
        
        if (!prepTimeData.contains(prepTimeTF.text ?? "")){
            error += "Please select a valid Preparation Time \n\n"
        }
            
        if (error != "") {
            let alert1 = UIAlertController(
                        title: error,
                        message: nil,
                        preferredStyle: .alert
                    )
                    
                    alert1.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: .default,
                            handler: nil
                    ))
            
            self.present(alert1, animated: true, completion: nil)
               
              return
        } else {
            let alert = UIAlertController(
                        title: "Are you sure you want to post this recipe?",
                        message: "",
                        preferredStyle: .alert
                    )
                    
                    alert.addAction(
                        UIAlertAction(
                            title: "Cancel",
                            style: .destructive,
                            handler: nil
                    ))
                    
                    alert.addAction(
                        UIAlertAction(
                            title: "Yes",
                            style: .default,
                            handler: {
                                action in
                                self.postItem = Posts(recipeName: "", username: "", mealType: "", likes: 0, healthy: 0, tagBudget: "", tagStyle: "", tagPrep: "", postImage: "", postComplete: "1")
                                
            //                    let pickerRowBudget = self.budgetPicker.selectedRow(inComponent: 0)
            //                    let selectedPickerTextBudget = self.budgetData[pickerRowBudget]
                                self.postItem!.tagBudget = self.budgetTF.text!

            //                    let pickerRowStyle = self.cookingStylePicker.selectedRow(inComponent: 0)
            //                    let selectedPickerTextCookStyle = self.cookStyleData[pickerRowStyle]
                                self.postItem!.tagStyle = self.cookingStyleTF.text!
                                
            //                    let pickerRowPrep = self.prepTimePicker.selectedRow(inComponent: 0)
            //                    let selectedPickerTextPrepTime = self.prepTimeData[pickerRowPrep]
                                self.postItem!.tagPrep = self.prepTimeTF.text!
                                
                                let vc = self.storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
                                
                                postsDataManager.FinishPost(self.postID!, self.postItem!)
                                self.show(vc, sender: self)
                                //test if clicking alert works
                        }
                    ))
                    
                    self.present(alert, animated: true, completion: nil)
                     
                    return
        }
    }
    
    @IBAction func cancelPostCreate(_ sender: Any) {
        postsDataManager.deletePost(postID!)
        IngredientsDataManager.deleteIngredientByPost(ingredients: ingredientList!)
        let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
        self.show(vc, sender: self)
    }
    
    
    @IBAction func backButtonClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "IngredientViewController") as! IngredientViewController
        vc.postID = self.postID
        self.show(vc, sender: self)
    }
}
