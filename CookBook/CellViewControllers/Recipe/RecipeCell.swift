//
//  RecipeCell.swift
//  CookBook
//
//  Created by ITP312Grp2 on 8/7/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

   @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeStepsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
