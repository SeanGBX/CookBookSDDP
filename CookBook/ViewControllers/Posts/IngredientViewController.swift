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
    
    var ingredientItemList : [Ingredients] = []
    var postID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("---->\(self.postID!)")
        
        loadIngredients()
    }
    
    public func loadIngredients(){
        IngredientsDataManager.loadIngredients(self.postID!){
            ingredientListFromFirestore in
            self.ingredientItemList = ingredientListFromFirestore
            self.ingredientTableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientItemCell", for: indexPath) as! IngredientItemCell
        let p = ingredientItemList[indexPath.row]
        cell.IngredientItemLabel.text = p.ingredient
        cell.ingredientItemImage.image = UIImage(named: p.ingredientImage)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditIngredient"){
            let ingredientInfoViewController = segue.destination as!
                IngredientInfoViewController
            let ingIndexPath = self.ingredientTableView.indexPathForSelectedRow
            ingredientInfoViewController.postID = self.postID
//            ingredientInfoViewController.addEditIngredientButton.setTitle("DONE", for: .normal)
            
            if (ingIndexPath != nil){
                let ingredient = ingredientItemList[ingIndexPath!.row]
                ingredientInfoViewController.ingredientItem = ingredient
            }
        }
        
        if (segue.identifier == "AddIngredient"){
            let ingredientInfoViewController = segue.destination as!
                IngredientInfoViewController
            ingredientInfoViewController.postID = self.postID
            let ingredient = Ingredients(postId: "", ingredient: "", ingredientImage: "", measureVal: 0, measureType: "")
            
//            ingredientInfoViewController.addEditIngredientButton.setTitle("ADD", for: .normal)
            ingredientInfoViewController.ingredientItem = ingredient
        }
    }
}
