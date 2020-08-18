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
    @IBOutlet weak var prepTimeTextField: UITextField!
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var findRecipeButton: UIButton!
    var cuisineTitle: String = ""
    
    var cuisinePickerData: [String] = ["Asian", "Western", "Mexican", "Middle-Eastern", "European", "African"]
    var budgetPickerData: [String] = ["Cheap", "Moderately-Priced", "Expensive"]
    var prepTimePickerData: [String] = ["Quick", "Moderate", "Long"]
    //var pickerView = UIPickerView()
    var budgetPickerView = UIPickerView()
    var prepTimePickerView = UIPickerView()
    var cuisinePickerView = UIPickerView()
    //var currentTextField = UITextField()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        budgetTextField.inputView = budgetPickerView
        prepTimeTextField.inputView = prepTimePickerView
        cuisineStyleTextField.inputView = cuisinePickerView
        
        budgetPickerView.delegate = self
        budgetPickerView.dataSource = self
        prepTimePickerView.delegate = self
        prepTimePickerView.dataSource = self
        cuisinePickerView.delegate = self
        cuisinePickerView.dataSource = self
        
        budgetPickerView.tag = 1
        prepTimePickerView.tag = 2
        cuisinePickerView.tag = 3
        
        budgetTextField.text = budgetPickerData[0]
        cuisineStyleTextField.text = cuisinePickerData[0]
        prepTimeTextField.text = prepTimePickerData[0]
        
        chosenCuisinLabel?.text = cuisineTitle
        self.navigationItem.setHidesBackButton(true, animated: true);
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKey")
        view.addGestureRecognizer(tap)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        budgetTextField.text = budgetPickerData[0]
//        cuisineStyleTextField.text = cuisinePickerData[0]
//        prepTimeTextField.text = prepTimePickerData[0]
//    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return budgetPickerData.count
            
        case 2:
            return prepTimePickerData.count
            
        case 3:
            return cuisinePickerData.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return budgetPickerData[row]
        case 2:
            return prepTimePickerData[row]
        case 3:
            return cuisinePickerData[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            budgetTextField.text = budgetPickerData[row]
            self.view.endEditing(true)
        case 2:
            prepTimeTextField.text = prepTimePickerData[row]
            self.view.endEditing(true)
        case 3:
            cuisineStyleTextField.text = cuisinePickerData[row]
            self.view.endEditing(true)
        default:
            self.view.endEditing(true)
        }
    }
    
    //func textFieldDidBeginEditing(_ textField: UITextField) {
    //    self.pickerView.delegate = self
    //    self.pickerView.dataSource = self
    //    currentTextField = textField
        
    //    if currentTextField == budgetTextField {
    //        currentTextField.inputView = pickerView
    //    }
            
    //    else if currentTextField == prepTimeTextField {
    //        currentTextField.inputView = pickerView
    //    }
        
    //    else if currentTextField == cuisineStyleTextField {
    //        currentTextField.inputView = pickerView
    //    }
    //}
    
    
    // Click function for the button to find recipes
    @IBAction func findRecipeButtonPressed(_ sender: Any) {
        if (budgetTextField.text == "" && prepTimeTextField.text == "" || budgetTextField.text == "" && cuisineStyleTextField.text == "" || prepTimeTextField.text == "" && prepTimeTextField.text == "" && cuisineStyleTextField.text == "")
        {
            let alert = UIAlertController(title: "There are missing field(s)", message: "Please fill in all the missing fields.", preferredStyle: UIAlertController.Style.alert)
                       
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                       
            self.present(alert, animated: true, completion: nil)
        }
        
        else if (budgetTextField.text == "") {
            let alert = UIAlertController(title: "There is a missing field", message: "You have left the preferred budget textfield blank. Please state your preferred budget.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        else if (prepTimeTextField.text == "") {
            let alert = UIAlertController(title: "There is a missing field", message: "Your preparation time should not be 0 mins.", preferredStyle: UIAlertController.Style.alert)
                       
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                       
            self.present(alert, animated: true, completion: nil)
        }
        
        else if (cuisineStyleTextField.text == "") {
            let alert = UIAlertController(title: "There is a missing field", message: "You have left he cuisine textfield blank. Please state your preferred cuisine.", preferredStyle: UIAlertController.Style.alert)
                       
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                       
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.destination is RecipeViewController) {
            let vc = segue.destination as? RecipeViewController
            vc?.budget = budgetTextField.text!
            vc?.prepTime = prepTimeTextField.text!
            vc?.chosenCuisine = chosenCuisinLabel.text!
            vc?.cuisineStyle = cuisineStyleTextField.text!
        }
    }
    
    
    // Back button function to perform the action of going back to the previous  page
    @IBAction func backButton(_ sender: Any) {
        let vc = UIStoryboard(name: "Meal", bundle: nil).instantiateViewController(identifier: "MealRecipe") as! ViewController
        
        self.show(vc, sender: self)
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
