//
//  RecipeCell.swift
//  CookBook
//
//  Created by ITP312Grp2 on 8/7/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

protocol loadRecipeInfo: class {
    func loadRecipeInfo(_ post: Posts, _ cuisine: String, _ budget: String, _ prepTime: String, _ mealType: String)
}

class RecipeCell: UITableViewCell {

    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeStepsLabel: UILabel!
    @IBOutlet weak var recipeButton: UIButton!
    var cuisine: String?
    var budget: String?
    var prepTime: String?
    var mealType: String?
    
    var recipe: Posts?
    var recipeList: [Posts] = []
    weak var delegate: loadRecipeInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func recipeButtonPressed(_ sender: Any) {
        
        self.delegate?.loadRecipeInfo(recipe!, mealType!, budget!, prepTime!, cuisine!)
    }
}
