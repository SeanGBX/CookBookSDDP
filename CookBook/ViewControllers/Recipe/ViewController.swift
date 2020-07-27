//
//  ViewController.swift
//  CookApp
//
//  Created by M09-3 on 9/6/20.
//  Copyright © 2020 M09-3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cuisineView: UIView!
    @IBOutlet weak var cuisinTitle: UILabel!
    @IBOutlet weak var brunchLabel: UILabel!
    @IBOutlet weak var appetizerLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var sauceSideLabel: UILabel!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var dessertLabel: UILabel!
    @IBOutlet weak var cuisineDescriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cuisineView.isHidden = true
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        brunchButton.setTitle("+", for: .normal)
        appetizerButton.setTitle("+", for: .normal)
        mainButton.setTitle("+", for: .normal)
        sauceSidesButton.setTitle("+", for: .normal)
        drinkButton.setTitle("+", for: .normal)
        dessertButton.setTitle("+", for: .normal)
        cuisineView.isHidden = true
    }
    
    @IBOutlet weak var brunchButton: UIButton!
    @IBOutlet weak var appetizerButton: UIButton!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var sauceSidesButton: UIButton!
    @IBOutlet weak var drinkButton: UIButton!
    @IBOutlet weak var dessertButton: UIButton!
    @IBOutlet weak var findRecipeButton: UIButton!
    
    
    @IBAction func brunchButtonPressed(_ sender: Any) {
        if (cuisineView.isHidden == true) {
            cuisinTitle.text = brunchLabel.text
            cuisineDescriptionLabel.text = "Brunch is a combination of breakfast and lunch, or it can also be refered to as a late morning meal. It is usually serves anytime before 3pm.\n\nExamples of brunch foods:\nDim Sum, Smoked salmon and egg salad on a toasted baguette, A Belgian waffle with strawberries and powdered sugar, etc."
            brunchButton.setTitle("-", for: .normal)
            cuisineView.isHidden = false
        }
        
        else {
            brunchButton.setTitle("+", for: .normal)
            appetizerButton.setTitle("+", for: .normal)
            mainButton.setTitle("+", for: .normal)
            sauceSidesButton.setTitle("+", for: .normal)
            drinkButton.setTitle("+", for: .normal)
            dessertButton.setTitle("+", for: .normal)
            cuisineView.isHidden = true
        }
    }
    
    @IBAction func appetizerButtonPressed(_ sender: Any) {
        if (cuisineView.isHidden == true) {
            cuisinTitle.text = appetizerLabel.text
            cuisineDescriptionLabel.text = "An appeitzer is a small dish of food or drink taken before a main course of the meal to stimulate one's appetite.\n\nExamples of appetizer foods:\nSalad, soup, etc."
            appetizerButton.setTitle("-", for: .normal)
            cuisineView.isHidden = false
        }
        
        else {
            appetizerButton.setTitle("+", for: .normal)
            brunchButton.setTitle("+", for: .normal)
            mainButton.setTitle("+", for: .normal)
            sauceSidesButton.setTitle("+", for: .normal)
            drinkButton.setTitle("+", for: .normal)
            dessertButton.setTitle("+", for: .normal)
            cuisineView.isHidden = true
        }
    }
    
    @IBAction func mainButtonPressed(_ sender: Any) {
        if (cuisineView.isHidden == true) {
            cuisinTitle.text = mainLabel.text
            cuisineDescriptionLabel.text = "Main course is the most substantial course of a meal, it is the heaviest and heartiest meal. Main course contains a main ingredient which is meat, fish or other protein source.\n\nExamples of main courses:\nChicken chop with rice, wanton noodle, spaghetti with ham and meatballs"
            mainButton.setTitle("-", for: .normal)
            cuisineView.isHidden = false
        }
        
        else {
            mainButton.setTitle("+", for: .normal)
            brunchButton.setTitle("+", for: .normal)
            appetizerButton.setTitle("+", for: .normal)
            sauceSidesButton.setTitle("+", for: .normal)
            drinkButton.setTitle("+", for: .normal)
            dessertButton.setTitle("+", for: .normal)
            cuisineView.isHidden = true
        }
    }
    
    @IBAction func sauceSidesButtonPressed(_ sender: Any) {
        if (cuisineView.isHidden == true) {
            cuisinTitle.text = sauceSideLabel.text
            cuisineDescriptionLabel.text = "What is a meal if it does not come with sauce like chili or tomato sauce and even better to have a side dish to accompany with your main course.\n\nExamples of side dishes:\nFrench fries, mashed potatoes, mac & cheese, etc."
            sauceSidesButton.setTitle("-", for: .normal)
            cuisineView.isHidden = false
        }
        
        else {
            brunchButton.setTitle("+", for: .normal)
            appetizerButton.setTitle("+", for: .normal)
            mainButton.setTitle("+", for: .normal)
            sauceSidesButton.setTitle("+", for: .normal)
            drinkButton.setTitle("+", for: .normal)
            dessertButton.setTitle("+", for: .normal)
            cuisineView.isHidden = true
        }
    }
    
    @IBAction func drinkButtonPressed(_ sender: Any) {
        if (cuisineView.isHidden == true) {
            cuisinTitle.text = drinkLabel.text
            cuisineDescriptionLabel.text = "How is a full meal without having drinks considered to be a complete meal. Not having drinks during your meal will make you feel thirsty and the dryness of your throat. It will be best for you to have a nice cold/hot drink to go with your meal"
            drinkButton.setTitle("-", for: .normal)
            cuisineView.isHidden = false
        }
        
        else {
            brunchButton.setTitle("+", for: .normal)
            appetizerButton.setTitle("+", for: .normal)
            mainButton.setTitle("+", for: .normal)
            sauceSidesButton.setTitle("+", for: .normal)
            drinkButton.setTitle("+", for: .normal)
            dessertButton.setTitle("+", for: .normal)
            cuisineView.isHidden = true
        }
    }
    
    
    @IBAction func dessertButtonPressed(_ sender: Any) {
        if (cuisineView.isHidden == true) {
            cuisinTitle.text = dessertLabel.text
            cuisineDescriptionLabel.text = "Lastly, it will be the best idea to end of a meal with dessert. Dessert is a course that will conclude your entire meal, it usually consists of sweet foods, such as confections.\n\nExamples of dessert foods:\nIce cream, cakes, jelly, etc."
            dessertButton.setTitle("-", for: .normal)
            cuisineView.isHidden = false
        }
        
        else {
            brunchButton.setTitle("+", for: .normal)
            appetizerButton.setTitle("+", for: .normal)
            mainButton.setTitle("+", for: .normal)
            sauceSidesButton.setTitle("+", for: .normal)
            drinkButton.setTitle("+", for: .normal)
            dessertButton.setTitle("+", for: .normal)
            cuisineView.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is FindRecipeViewController) {
            if (cuisinTitle.text == brunchLabel.text) {
                let vc = segue.destination as? FindRecipeViewController
                vc?.cuisineTitle = brunchLabel.text!
            }
            
            else if (cuisinTitle.text == appetizerLabel.text) {
                let vc = segue.destination as? FindRecipeViewController
                vc?.cuisineTitle = appetizerLabel.text!
            }
            
            else if (cuisinTitle.text == mainLabel.text) {
                let vc = segue.destination as? FindRecipeViewController
                vc?.cuisineTitle = mainLabel.text!
            }
            
            else if (cuisinTitle.text == sauceSideLabel.text) {
                let vc = segue.destination as? FindRecipeViewController
                vc?.cuisineTitle = sauceSideLabel.text!
            }
            
            else if (cuisinTitle.text == drinkLabel.text) {
                let vc = segue.destination as? FindRecipeViewController
                vc?.cuisineTitle = drinkLabel.text!
            }
            
            else {
                let vc = segue.destination as? FindRecipeViewController
                vc?.cuisineTitle = dessertLabel.text!
            }
        }
    }
    
    
}

