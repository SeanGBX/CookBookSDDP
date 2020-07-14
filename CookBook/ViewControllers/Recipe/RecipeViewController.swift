//
//  RecipeViewController.swift
//  CookApp
//
//  Created by M09-3 on 24/6/20.
//  Copyright © 2020 M09-3. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredRecipes.count
        }
        
        else {
            return recipeList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        
        let recipe: Posts
        
        if isFiltering {
            recipe = filteredRecipes[indexPath.row]
        }
        
        else {
            recipe = recipeList[indexPath.row]
        }
        
        cell.recipeTitleLabel.text = recipe.recipeName
        
        return cell
    }
    
    
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var cuisineStyleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    var chosenCuisine: String = ""
    var budget: String = ""
    var prepTime: String = ""
    var cuisineStyle: String = ""
    var recipeItem: Posts?
    var recipeList: [Posts] = []
    var filteredRecipes: [Posts] = []
    var recipe: PostViewController?
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        budgetLabel?.text = budget
        prepTimeLabel?.text = prepTime
        titleLabel?.text = chosenCuisine.capitalized
        cuisineStyleLabel?.text = cuisineStyle
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Recipes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        loadRecipes()
        // Do any additional setup after loading the view.
    }
    
    func loadRecipes() {
        RecipeDataManager.loadRecipes(self.chosenCuisine, budget: self.budget, prepTime: self.prepTime, cuisineStyle: self.cuisineStyle) {
            recipeListFromFirestore in
            self.recipeList = recipeListFromFirestore
            print(self.recipeList.count)
            
            if self.recipeList.count == 0 {
                self.recipeNameLabel.text = "There are no recipes found!"
                self.recipeTableView.isHidden = true
            }
            
            else {
                self.recipeNameLabel.text = ""
                self.recipeTableView.reloadData()
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if segue.destination is PostInfoViewController {
//            let PostInfoViewController = segue.destination as! PostInfoViewController

            
//            let myIndexPath = recipe?.tableView.indexPathForSelectedRow
            
//            if (myIndexPath != nil) {
//                let recipe = recipeList[myIndexPath!.row]
//                PostInfoViewController.postItem = recipe
//            }
//        }
//    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String, category: Posts? = nil) {
        filteredRecipes = recipeList.filter { (recipe: Posts) -> Bool in
            return recipe.recipeName.lowercased().contains(searchText.lowercased())
        }
        
        recipeTableView.reloadData()
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
