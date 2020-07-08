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
    var ingredientList : [Ingredients] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadIngredients()
    }
    
    func loadIngredients(){
        IngredientsDataManager.loadIngredients(postItem!.postId){
            ingredientFromFirestore in
            self.ingredientList = ingredientFromFirestore
            self.ingredientTable.reloadData()
        }
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
        return ingredientList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if (tableView == ingredientTable) {
            let p = ingredientList[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientCell
            
            cell.ingredientLabel.text = "\(p.ingredient) - \(p.measureVal) \(p.measureType)"
            
            cell.ingredientImage.image = UIImage(named: p.ingredientImage)
            
            return cell
        } else if (tableView == stepTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath) as! StepCell
            let s = ingredientList[indexPath.row]
            print("---->\(s.step)")
            cell.stepLabel.text = "\(s.step.prefix(30))..."
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
