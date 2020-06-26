//
//  PostInfoViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/15/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class PostInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ingredientTable: UITableView!
    @IBOutlet weak var stepTable: UITableView!
    @IBOutlet weak var postInfoImage: UIImageView!
    @IBOutlet weak var postInfoRecipeName: UILabel!
    @IBOutlet weak var postInfoUsername: UILabel!
    @IBOutlet weak var postInfoLCH: UILabel!
    @IBOutlet weak var postInfoTags: UILabel!
    
    var postItem: Posts?
    var ingredientStepsList : [IngredientSteps] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientStepsList.append(IngredientSteps(
            postId : 1,
            ingredient: "tomato",
            step: "cut tomato",
            ingredientImage: "bastion"
        ))
        
        ingredientStepsList.append(IngredientSteps(
            postId : 1,
            ingredient: "potato",
            step: "cut potato",
            ingredientImage: "bastion"
        ))
        
        ingredientStepsList.append(IngredientSteps(
            postId : 1,
            ingredient: "chicken",
            step: "cut chicken",
            ingredientImage: "bastion"
        ))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        postInfoImage.image = UIImage(named: postItem!.postImage)
        postInfoRecipeName.text = postItem?.recipeName
        postInfoUsername.text = postItem?.username
        postInfoLCH.text = "\(postItem!.likes) likes, 3 comments, \(postItem!.healthy) find this healthy"
        postInfoTags.text = "\(postItem!.tagBudget), \(postItem!.tagStyle), \(postItem!.tagPrep)"
        
        self.navigationItem.title = postItem?.recipeName
    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientStepsList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if (tableView === ingredientTable) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientCell
            let p = ingredientStepsList[indexPath.row]
            cell.ingredientLabel.text = p.ingredient
            cell.ingredientImage.image = UIImage(named: p.ingredientImage)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepsCell", for: indexPath) as! StepsCell
            let p = ingredientStepsList[indexPath.row]
            cell.stepLabel.text = p.step
            return cell
        }
    
    }
    
}
