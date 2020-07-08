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
    
    @IBOutlet weak var stepTableView: UITableView!
    
    var ingredientItemList : [Ingredients] = []
    var stepItemList: [Steps] = []
    var postID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        loadIngredients()
        loadSteps()
    }
    
    func loadIngredients(){
        IngredientsDataManager.loadIngredients(self.postID!){
            ingredientListFromFirestore in
            self.ingredientItemList = ingredientListFromFirestore
            self.ingredientTableView.reloadData()
        }
    }
    
    func loadSteps(){
        stepsDataManager.loadSteps(self.postID!){
            stepListFromFirestore in
            self.stepItemList = stepListFromFirestore
            self.stepTableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == ingredientTableView){
            return ingredientItemList.count
        } else if (tableView == stepTableView){
            return stepItemList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == ingredientTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientItemCell", for: indexPath) as! IngredientItemCell
            let p = ingredientItemList[indexPath.row]
            cell.IngredientItemLabel.text = "\(p.ingredient) - \(p.measureVal) \(p.measureType)"
            cell.ingredientItemImage.image = UIImage(named: p.ingredientImage)
            return cell
        } else if (tableView == stepTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepItemCell", for: indexPath) as! StepItemCell
            let s = stepItemList[indexPath.row]
            cell.stepItemLabel.text = "\(s.stepDesc.prefix(30))..."
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "EditIngredient"){
            let ingredientInfoViewController = segue.destination as!
                IngredientInfoViewController
            let ingIndexPath = self.ingredientTableView.indexPathForSelectedRow
            ingredientInfoViewController.postID = self.postID
            ingredientInfoViewController.segueIdentifier = segue.identifier
            
            if (ingIndexPath != nil){
                let ingredient = ingredientItemList[ingIndexPath!.row]
                ingredientInfoViewController.ingredientItem = ingredient
            }
        }
        
        if (segue.identifier == "AddIngredient"){
            let ingredientInfoViewController = segue.destination as!
                IngredientInfoViewController
            ingredientInfoViewController.postID = self.postID
            ingredientInfoViewController.segueIdentifier = segue.identifier
            let ingredient = Ingredients(postId: "", ingredient: "", ingredientImage: "", measureVal: 0, measureType: "")
            ingredientInfoViewController.ingredientItem = ingredient
        }
    }
    
    @IBAction func proceedToSteps(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "FinishPostViewController") as! FinishPostViewController
        
        vc.postID = self.postID!
        vc.ingredientList = ingredientItemList
        self.show(vc, sender: self)
    }
    
    
    @IBAction func cancelCreatePost(_ sender: Any) {
        postsDataManager.deletePost(postID!)
        IngredientsDataManager.deleteIngredientByPost(ingredients: ingredientItemList)
        let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
        self.show(vc, sender: self)
    }
}
