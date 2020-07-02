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
    
    var ingredientItem: Ingredients?
    var postID: String?
    
    var measurementTypeData : [String] = [
        "ml",
        "l",
        "g",
        "mg",
        "cup",
        "tbsp",
        "tsp",
        "oz",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("xxxxxx\(postID!)")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ingredientInfoImage.image = UIImage(named: ingredientItem!.ingredientImage)
        ingredientInfoName.text = ingredientItem?.ingredient
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
        var errors = ""
        
        if (ingredientInfoMeasureVal.text == ""){
            errors += "Please enter a measurement value\n"
        }
        if (ingredientInfoName.text == ""){
            errors += "Please enter an ingredient name\n"
        }
        
        var measureVal = Int(ingredientInfoMeasureVal.text!)
        
//        if (measureVal! <= 0 || measureVal! is Int){
//            errors += "Please enter a valid measurement value\n"
//        }
        
        let vc = storyboard?.instantiateViewController(identifier: "IngredientViewController") as! IngredientViewController
        
        ingredientItem!.ingredient = ingredientInfoName.text!
        ingredientItem!.ingredientImage = ""
        ingredientItem!.postId = postID!
        ingredientItem!.measureVal = measureVal!
        ingredientItem!.measureType = ""
        
        IngredientsDataManager.insertIngredient(ingredientItem!)
        
        print("----->\(self.postID!)")
        vc.postID = self.postID!
        vc.loadIngredients()
        self.show(vc, sender: self)
    }
}
