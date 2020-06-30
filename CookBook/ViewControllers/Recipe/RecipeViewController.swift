//
//  RecipeViewController.swift
//  CookApp
//
//  Created by M09-3 on 24/6/20.
//  Copyright © 2020 M09-3. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var cuisineStyleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var chosenCuisine: String = ""
    var budget: String = ""
    var prepTime: String = ""
    var cuisineStyle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        budgetLabel?.text = budget
        prepTimeLabel?.text = prepTime
        titleLabel?.text = chosenCuisine.capitalized
        cuisineStyleLabel?.text = cuisineStyle

        // Do any additional setup after loading the view.
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
