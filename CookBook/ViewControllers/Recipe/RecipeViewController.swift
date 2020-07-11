//
//  RecipeViewController.swift
//  CookApp
//
//  Created by M09-3 on 24/6/20.
//  Copyright © 2020 M09-3. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        
        let recipe = recipeList[indexPath.row]
        cell.recipeTitleLabel.text = recipe.recipeName
        
        return cell
    }
    
    
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var cuisineStyleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recipeTableView: UITableView!
    var chosenCuisine: String = ""
        var budget: String = ""
        var prepTime: String = ""
        var cuisineStyle: String = ""
        var recipeList: [Posts] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            budgetLabel?.text = budget
            prepTimeLabel?.text = prepTime
            titleLabel?.text = chosenCuisine.capitalized
            cuisineStyleLabel?.text = cuisineStyle
            recipeTableView.delegate = self
            recipeTableView.dataSource = self
            loadRecipes()

            // Do any additional setup after loading the view.
        }
        
        func loadRecipes() {
            RecipeDataManager.loadRecipes() {
                recipeListFromFirestore in
                self.recipeList = recipeListFromFirestore

                self.recipeTableView.reloadData()
            }
            
//            postsDataManager.loadCompletePosts(){
//                postListFromFirestore in
//                self.recipeList = postListFromFirestore
//                print(postListFromFirestore.count)
//                print(self.recipeList.count)
//                self.recipeTableView.reloadData()
//            }
        }
        
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return recipeList.count
//        }
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
//
//            let recipe = recipeList[indexPath.row]
//            cell.recipeTitleLabel.text = recipe.recipeName
//
//            return cell
//        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
