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
    @IBOutlet weak var ingredientInfoStepDescription: UITextField!
    @IBOutlet weak var ingredientInfoImage: UIImageView!
    
    var ingredientItem: IngredientSteps?
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ingredientInfoImage.image = UIImage(named: ingredientItem!.ingredientImage)
        ingredientInfoName.text = ingredientItem?.ingredient
        ingredientInfoStepDescription.text = ingredientItem?.step
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
}
