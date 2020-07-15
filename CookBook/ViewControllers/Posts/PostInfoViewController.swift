//
//  PostInfoViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/15/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseStorage

class PostInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ingredientTable: UITableView!
    @IBOutlet weak var stepTable: UITableView!
    @IBOutlet weak var postInfoImage: UIImageView!
    @IBOutlet weak var postInfoRecipeName: UILabel!
    @IBOutlet weak var postInfoUsername: UILabel!
    @IBOutlet weak var postInfoLCH: UILabel!
    @IBOutlet weak var postInfoTags: UILabel!
    
    var postItem: Posts?
    var ingredientList : [IngredientSteps] = []
    var stepList : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadIngredients()
        loadSteps()
    }
    
    func loadIngredients(){
        IngredientsDataManager.loadCompleteIngredients(postItem!.postId){
            ingredientFromFirestore in
            self.ingredientList = ingredientFromFirestore
            self.ingredientTable.reloadData()
        }
    }
    
    func loadSteps(){
        IngredientsDataManager.loadOnlySteps(postItem!.postId){
            stepFromFirestore in
            self.stepList = stepFromFirestore
            self.stepTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let imageRef = Storage.storage().reference(withPath: postItem!.postImage)
        imageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            if let data = data {
                self?.postInfoImage.image = UIImage(data: data)
            }
        }
    
        postInfoRecipeName.text = postItem?.recipeName
        postInfoUsername.text = postItem?.username
        postInfoLCH.text = "\(postItem!.likes) likes, 3 comments, \(postItem!.healthy) find this healthy"
        postInfoTags.text = "\(postItem!.tagBudget), \(postItem!.tagStyle), \(postItem!.tagPrep)"
        
        self.navigationItem.title = postItem?.recipeName
    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == ingredientTable) {
            return ingredientList.count
        } else if (tableView == stepTable) {
            return stepList.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if (tableView == ingredientTable) {
                let p = ingredientList[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientCell
            
            cell.ingredientLabel.text = "\(p.ingredient) - \(p.measureVal) \(p.measureType)"
            let ingredientImageRef = Storage.storage().reference(withPath: p.ingredientImage)
            ingredientImageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                if let data = data {
                    cell.ingredientImage.image = UIImage(data: data)
                }
            }
            
            return cell
        } else if (tableView == stepTable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath) as! StepCell
            let s = stepList[indexPath.row]
            cell.stepLabel.text = "\(indexPath.row + 1).  \(s.prefix(30))..."
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
