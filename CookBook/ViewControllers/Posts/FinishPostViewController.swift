//
//  FinishPostViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/17/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class FinishPostViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var budgetPicker: UIPickerView!
    
    @IBOutlet weak var cookingStylePicker: UIPickerView!
    
    @IBOutlet weak var prepTimePicker: UIPickerView!
    
    var postID: String?
    var postItem: Posts?
    
    var budgetData : [String] = ["Cheap","Moderately-priced","Expensive"]
    var cookStyleData : [String] = ["Asian", "Western", "Mexican", "Middle-Eastern"]
    var prepTimeData : [String] = ["Quick", "Moderate", "Long"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("---->\(self.postID!)")
        // Do any additional setup after loading the view.
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
        postItem = Posts(recipeName: "", username: "", mealType: "", likes: 0, healthy: 0, tagBudget: "", tagStyle: "", tagPrep: "", postImage: "")
        
        let pickerRowBudget = budgetPicker.selectedRow(inComponent: 0)
        let selectedPickerTextBudget = budgetData[pickerRowBudget]
        postItem!.tagBudget = selectedPickerTextBudget

        let pickerRowStyle = cookingStylePicker.selectedRow(inComponent: 0)
        let selectedPickerTextCookStyle = cookStyleData[pickerRowStyle]
        postItem!.tagStyle = selectedPickerTextCookStyle
        
        let pickerRowPrep = prepTimePicker.selectedRow(inComponent: 0)
        let selectedPickerTextPrepTime = prepTimeData[pickerRowPrep]
        postItem!.tagPrep = selectedPickerTextPrepTime
        
        let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
        
        postsDataManager.FinishPost(postID!, postItem!)
        self.show(vc, sender: self)
    }
    
}
