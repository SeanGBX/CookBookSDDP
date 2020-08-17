//
//  RecipeViewController.swift
//  CookApp
//
//  Created by M09-3 on 24/6/20.
//  Copyright © 2020 M09-3. All rights reserved.
//

import UIKit
import FirebaseStorage

class RecipeViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, loadRecipeInfo {
    
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
        //let recipeStep: IngredientSteps
        
        if isFiltering {
            recipe = filteredRecipes[indexPath.row]
        }
        
        else {
            recipe = recipeList[indexPath.row]
        }
        
        cell.recipeTitleLabel.text = "Recipe name: \(recipe.recipeName)"
        //cell.recipeTitleLabel.text = "Likes: \(recipe.likes)"
        // cell.recipeStepsLabel.text = recipeSteps.step
        //cell.recipeStepsLabel.text = recipeStep.step
        
        let labelConstraint = NSLayoutConstraint(item: cell.recipeTitleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        cell.recipeTitleLabel.addConstraint(labelConstraint)
        
        cell.cuisine = recipe.tagStyle
        cell.budget = recipe.tagBudget
        cell.prepTime = recipe.tagPrep
        cell.mealType = recipe.mealType
        cell.delegate = self
        cell.recipe = recipe
        print(">> \(recipe.likes)")
        
        let image = Storage.storage().reference(withPath: recipe.postImage)
        image.getData(maxSize: 4 * 1024 * 1024) {
            [weak self] (data, error) in
            if let error = error {
                print("Error in getting the image: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                cell.recipeImage.image = UIImage(data: data)
                let imageViewWidthConstraint = NSLayoutConstraint(item: cell.recipeImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
                let imageViewHeightConstraint = NSLayoutConstraint(item: cell.recipeImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
                cell.recipeImage.addConstraints([imageViewWidthConstraint, imageViewHeightConstraint])
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260.0
    }
    
    func loadRecipeInfo(_ post: Posts, _ chosenCuisine: String, _ budget: String, _ prepTime: String, _ mealType: String) {
        let vc = UIStoryboard(name: "Posts", bundle: nil).instantiateViewController(identifier: "PostInfoViewController") as! PostInfoViewController
        
        vc.postItem = post
        vc.isCuisine = chosenCuisine
        vc.isBudget = budget
        vc.isPrepTime = prepTime
        vc.isMealtype = mealType
        self.show(vc, sender: self)
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
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        // Do any additional setup after loading the view.
    }
    
    func loadRecipes() {
        RecipeDataManager.loadRecipes(self.chosenCuisine, budget: self.budget, prepTime: self.prepTime, cuisineStyle: self.cuisineStyle) {
            recipeListFromFirestore in
            self.recipeList = recipeListFromFirestore
            print("-->\(self.recipeList.count)")
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = storyboard?.instantiateViewController(identifier: "PostInfoViewController") as! PostInfoViewController
        
        let myIndexPath = self.recipeTableView.indexPathForSelectedRow
        
        if (myIndexPath != nil) {
            let recipe = recipeList[myIndexPath!.row]
            vc.postItem = recipe
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String, category: Posts? = nil) {
        filteredRecipes = recipeList.filter { (recipe: Posts) -> Bool in
            return recipe.recipeName.lowercased().contains(searchText.lowercased())
        }
        
        updateLabel()
        recipeTableView.reloadData()
    }
    
    func updateLabel() {
        if filteredRecipes.isEmpty && isFiltering {
            self.recipeNameLabel.text = "No recipes found!"
            self.recipeNameLabel.isHidden = false
            self.recipeTableView.isHidden = true
        }
        
        else {
            self.recipeNameLabel.isHidden = true
            self.recipeTableView.isHidden = false
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        let vc = UIStoryboard(name: "FindRecipe", bundle: nil).instantiateViewController(identifier: "FindRecipeViewController") as! FindRecipeViewController
        
        vc.cuisineTitle = chosenCuisine
        
        self.show(vc, sender: self)
    }

}
