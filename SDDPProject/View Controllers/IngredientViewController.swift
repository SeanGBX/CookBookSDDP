//
//  IngredientViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/16/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class IngredientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var ingredientTableView: UITableView!
    
    var ingredientItemList : [IngredientSteps] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientItemList.append(IngredientSteps(
            postId : 1,
            ingredient: "tomato",
            step: "cut tomato",
            ingredientImage: "bastion"
        ))
        
        ingredientItemList.append(IngredientSteps(
            postId : 1,
            ingredient: "potato",
            step: "cut potato",
            ingredientImage: "bastion"
        ))
        
        ingredientItemList.append(IngredientSteps(
            postId : 1,
            ingredient: "chicken",
            step: "cut chicken",
            ingredientImage: "bastion"
        ))
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientItemCell", for: indexPath) as! IngredientItemCell
        let p = ingredientItemList[indexPath.row]
        cell.IngredientItemLabel.text = p.step
        cell.ingredientItemImage.image = UIImage(named: p.ingredientImage)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditIngredient"){
            let ingredientInfoViewController = segue.destination as!
                IngredientInfoViewController
            let ingIndexPath = self.ingredientTableView.indexPathForSelectedRow
            
            if (ingIndexPath != nil){
                let ingredient = ingredientItemList[ingIndexPath!.row]
                ingredientInfoViewController.ingredientItem = ingredient
            }
        }
        
        if (segue.identifier == "AddIngredient"){
            let ingredientInfoViewController = segue.destination as!
                IngredientInfoViewController
            
            let ingredient = IngredientSteps(postId: 0, ingredient: "", step: "", ingredientImage: "")
            
            ingredientInfoViewController.ingredientItem = ingredient
        }
    }
}
