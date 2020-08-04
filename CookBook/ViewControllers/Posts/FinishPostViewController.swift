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
    
    
    @IBOutlet weak var budgetPicker: UIPickerView!
    
    @IBOutlet weak var cookingStylePicker: UIPickerView!
    
    @IBOutlet weak var prepTimePicker: UIPickerView!
    
    @IBOutlet weak var finalImage: UIImageView!
    
    @IBOutlet weak var finalName: UILabel!
    
    var postID: String?
    var postItem: Posts?
    var selectedPost: [Posts] = []
    var ingredientList: [IngredientSteps]?
    
    var budgetData : [String] = ["Cheap","Moderately-Priced","Expensive"]
    var cookStyleData : [String] = ["Asian", "Western", "Mexican", "Middle-Eastern"]
    var prepTimeData : [String] = ["Quick", "Moderate", "Long"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true);
        loadSpecificPost()
        // Do any additional setup after loading the view.
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
        if (pickerView === budgetPicker) {
            return budgetData.count
        }
        else if (pickerView === cookingStylePicker) {
            return cookStyleData.count
        }
        else {
            return prepTimeData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView === budgetPicker) {
            return budgetData[row]
        }
        else if (pickerView === cookingStylePicker) {
            return cookStyleData[row]
        }
        else {
            return prepTimeData[row]
        }
    }
    
    
    @IBAction func postRecipeButton(_ sender: Any) {
        
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
                    
                    let pickerRowBudget = self.budgetPicker.selectedRow(inComponent: 0)
                    let selectedPickerTextBudget = self.budgetData[pickerRowBudget]
                    self.postItem!.tagBudget = selectedPickerTextBudget

                    let pickerRowStyle = self.cookingStylePicker.selectedRow(inComponent: 0)
                    let selectedPickerTextCookStyle = self.cookStyleData[pickerRowStyle]
                    self.postItem!.tagStyle = selectedPickerTextCookStyle
                    
                    let pickerRowPrep = self.prepTimePicker.selectedRow(inComponent: 0)
                    let selectedPickerTextPrepTime = self.prepTimeData[pickerRowPrep]
                    self.postItem!.tagPrep = selectedPickerTextPrepTime
                    
                    let vc = self.storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
                    
                    postsDataManager.FinishPost(self.postID!, self.postItem!)
                    self.show(vc, sender: self)
                    //test if clicking alert works
            }
        ))
        
        self.present(alert, animated: true, completion: nil)
         
        return
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
