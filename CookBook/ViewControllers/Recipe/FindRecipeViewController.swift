//
//  FindRecipeViewController.swift
//  CookApp
//
//  Created by M09-3 on 20/6/20.
//  Copyright © 2020 M09-3. All rights reserved.
//

import UIKit

class FindRecipeViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var chosenCuisinLabel: UILabel!
    @IBOutlet weak var cuisineStlyeLabel: UILabel!
    @IBOutlet weak var cuisineStyleTextField: UITextField!
//    @IBOutlet weak var cuisineStylePickerView: UIPickerView!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var prepSlider: UISlider!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var findRecipeButton: UIButton!
//    @IBOutlet weak var budgetPickerView: UIPickerView!
    var cuisineTitle: String = ""
    
    var cuisinePickerData: [String] = []
    var budgetPickerData: [String] = []
    var pickerView = UIPickerView()
    var currentTextField = UITextField()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        budgetPickerData = ["Expensive", "Average", "Budget friendly"]
        cuisinePickerData = ["Western", "Asian"]
        chosenCuisinLabel?.text = cuisineTitle
        prepTimeLabel.text = "0 mins"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepTimeLabel.text = "0 mins"
        prepSlider.value = 0.0
        budgetTextField.text = ""
        cuisineStyleTextField.text = cuisinePickerData[0]
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == budgetTextField {
            return budgetPickerData.count
        }
        
        else if currentTextField == cuisineStyleTextField {
            return cuisinePickerData.count
        }
        
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == budgetTextField {
            return budgetPickerData[row]
        }
        
        else if currentTextField == cuisineStyleTextField {
            return cuisinePickerData[row]
        }
        
        else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == budgetTextField {
            budgetTextField.text = budgetPickerData[row]
            self.view.endEditing(true)
        }
        
        else if currentTextField == cuisineStyleTextField {
            cuisineStyleTextField.text = cuisinePickerData[row]
            self.view.endEditing(true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        currentTextField = textField
        if currentTextField == budgetTextField {
            currentTextField.inputView = pickerView
        }
        
        else if currentTextField == cuisineStyleTextField {
            currentTextField.inputView = pickerView
        }
    }
    
    @IBAction func prepSliderValueChanged(_ sender: UISlider) {
        prepTimeLabel.text = String(format: "%i mins", Int(sender.value))
    }
    
    @IBAction func findRecipeButtonPressed(_ sender: Any) {
        if (budgetTextField.text == "" || prepSlider.value == 0.0 || cuisineStyleTextField.text == "") {
            let alert = UIAlertController(title: "There are missing field(s)", message: "You need to fill in all fields in order to move on to the next page", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is RecipeViewController) {
            let vc = segue.destination as? RecipeViewController
            vc?.budget = budgetTextField.text!
            vc?.prepTime = prepTimeLabel.text!
            vc?.chosenCuisine = "List of " + chosenCuisinLabel.text! + " recipes"
            vc?.cuisineStyle = cuisineStyleTextField.text!
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
