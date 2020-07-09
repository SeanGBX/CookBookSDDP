//
//  IngredientInfoViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/16/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class IngredientInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var ingredientInfoName: UITextField!
    @IBOutlet weak var ingredientInfoMeasureVal: UITextField!
    @IBOutlet weak var ingredientInfoMeasureType: UIPickerView!
    @IBOutlet weak var ingredientInfoImage: UIImageView!
    @IBOutlet weak var addEditIngredientButton: UIButton!
    @IBOutlet weak var stepInfo: UITextField!
    @IBOutlet weak var enableIngredientSwitch: UISwitch!
    @IBOutlet weak var enableIngredientLabel: UILabel!
    
    var ingredientItem: IngredientSteps?
    var postID: String?
    var segueIdentifier: String?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ingredientItem != nil {
            ingredientInfoImage.image = UIImage(named: ingredientItem!.ingredientImage)
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
                if (ingredientItem!.ingredient != "") {
                    enableIngredientSwitch.isOn = true
                    
                    ingredientInfoMeasureVal.isHidden = false
                    ingredientInfoMeasureType.isHidden = false
                    ingredientInfoName.isHidden = false
                    ingredientInfoImage.isHidden = false
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
    
    @IBAction func addEditIngredient(_ sender: Any) {
        var error = ""
        
        if (enableIngredientSwitch.isOn == true){
            
            if (ingredientInfoMeasureVal.text == "" || ingredientInfoMeasureVal.text == "0"){
                error += "Please enter a valid measurement value\n"
            }
            if (ingredientInfoName.text == ""){
                error += "Please enter an ingredient name\n"
            }
        }
        
        if (stepInfo.text == ""){
            error += "Please enter step information"
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
        
        let measureValue = Int(ingredientInfoMeasureVal.text!)
        
//        if (measureVal! <= 0 || measureVal! is Int){
//            errors += "Please enter a valid measurement value\n"
//        }
        
        let vc = storyboard?.instantiateViewController(identifier: "IngredientViewController") as! IngredientViewController
        
        if (enableIngredientSwitch.isOn == true){
            ingredientItem!.ingredient = ingredientInfoName.text!
            ingredientItem!.ingredientImage = "default"
            ingredientItem!.measureVal = measureValue != nil ? measureValue! : 0
            
            let pickerRow = ingredientInfoMeasureType.selectedRow(inComponent: 0)
            let selectedPickerText = measurementTypeData[pickerRow]
            ingredientItem!.measureType = selectedPickerText
            
        } else {
            ingredientItem!.ingredient = ingredientInfoName.text!
            ingredientItem!.ingredientImage = ""
            ingredientItem!.measureVal = measureValue != nil ? measureValue! : 0
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
            
            self.show(vc, sender: self)
        }
        else{
            let vc = storyboard?.instantiateViewController(identifier: "IngredientViewController") as! IngredientViewController
        
            IngredientsDataManager.deleteIngredient(ingredient: ingredientItem!)
            self.show(vc, sender: self)
        }
    }
    
    @IBAction func enableIngredient(_ sender: Any) {
        if (enableIngredientSwitch.isOn == true){
            ingredientInfoMeasureVal.isHidden = false
            ingredientInfoMeasureType.isHidden = false
            ingredientInfoName.isHidden = false
            ingredientInfoImage.isHidden = false
        } else {
            ingredientInfoMeasureVal.isHidden = true
            ingredientInfoMeasureType.isHidden = true
            ingredientInfoName.isHidden = true
            ingredientInfoImage.isHidden = true
        }
    }
}
