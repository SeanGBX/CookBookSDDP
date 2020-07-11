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
    var postID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        loadIngredients()
    }
    
    func loadIngredients(){
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
        cell.IngredientItemLabel.text = "\(p.step.prefix(30))..."
        cell.ingredientItemImage.image = UIImage(named: p.ingredientImage)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "EditIngredient"){
            let ingredientInfoViewController = segue.destination as!
                IngredientInfoViewController
            let ingIndexPath = self.ingredientTableView.indexPathForSelectedRow
            ingredientInfoViewController.postID = self.postID
            ingredientInfoViewController.segueIdentifier = segue.identifier
            
            if (ingIndexPath != nil){
                ingredientInfoViewController.ingredientIndex = ingIndexPath!.row
                let ingredient = ingredientItemList[ingIndexPath!.row]
                ingredientInfoViewController.ingredientItem = ingredient
            }
        }
        
        if (segue.identifier == "AddIngredient"){
            let ingredientInfoViewController = segue.destination as!
                IngredientInfoViewController
            ingredientInfoViewController.postID = self.postID
            ingredientInfoViewController.segueIdentifier = segue.identifier
            let ingredient = IngredientSteps(postId: "", ingredient: "", step: "", ingredientImage: "default", measureVal: 0, measureType: "")
            ingredientInfoViewController.ingredientItem = ingredient
        }
    }
    
    @IBAction func proceedToSteps(_ sender: Any) {
        
        if (ingredientItemList == []){
            
           let alert = UIAlertController(
               title: "Please add at least 1 step",
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
            
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "FinishPostViewController") as! FinishPostViewController
            
            vc.postID = self.postID!
            vc.ingredientList = ingredientItemList
            self.show(vc, sender: self)
        }
    }
    
    
    @IBAction func cancelCreatePost(_ sender: Any) {
        postsDataManager.deletePost(postID!)
        IngredientsDataManager.deleteIngredientByPost(ingredients: ingredientItemList)
        let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
        self.show(vc, sender: self)
    }
}
