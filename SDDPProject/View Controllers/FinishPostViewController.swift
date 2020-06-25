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
    
    var budgetData : [String] = ["Cheap","Moderately-priced","Expensive"]
    var cookStyleData : [String] = ["Asian", "Western", "Mexican", "Middle-Eastern"]
    var prepTimeData : [String] = ["Quick", "Moderate", "Long"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

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

}
