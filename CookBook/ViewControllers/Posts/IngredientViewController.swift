//
//  IngredientViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/16/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseStorage

class IntrinsicIngredientTableView: UITableView {

    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

}

class IngredientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var ingredientItemList : [IngredientSteps] = []
    var postID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        print("-.-\(self.postID!)")
        loadIngredients()
        if (ingredientItemList.count > 0){
            noLabel.isHidden = true
            nextButton.isHidden = false
            
        } else {
            noLabel.isHidden = false
            nextButton.isHidden = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeightConstraint?.constant = self.ingredientTableView.intrinsicContentSize.height
    }
    
    func loadIngredients(){
        IngredientsDataManager.loadIngredients(self.postID!){
            ingredientListFromFirestore in
            self.ingredientItemList = ingredientListFromFirestore
            self.ingredientTableView.reloadData()
            if (self.ingredientItemList.count > 0){
                self.noLabel.isHidden = true
                self.nextButton.isHidden = false
            } else {
                self.noLabel.isHidden = false
                self.nextButton.isHidden = true
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (ingredientItemList.count == 0){
            var emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No ingredients have been added"
            emptyLabel.textAlignment = NSTextAlignment.center
            self.ingredientTableView.backgroundView = emptyLabel
            self.ingredientTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return 0
        } else {
            self.ingredientTableView.backgroundView = nil
            self.ingredientTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            return ingredientItemList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientItemCell", for: indexPath) as! IngredientItemCell
        let p = ingredientItemList[indexPath.row]
        if (p.step.count > 40){
            cell.IngredientItemLabel.text = "\(p.step.prefix(40))..."
        } else {
            cell.IngredientItemLabel.text = p.step
        }
        let imageRef = Storage.storage().reference(withPath: p.ingredientImage)
        imageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            if let data = data {
                cell.ingredientItemImage.image = UIImage(data: data)
            }
        }
//        self.tableHeightConstraint?.constant = self.ingredientTableView.contentSize.height
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
        
        var notEmptyIngredients = 0
        
        for i in ingredientItemList{
            if (i.ingredient != ""){
                notEmptyIngredients += 1
            }
        }
        
        
        if (ingredientItemList.count == 0){
            
           let alert = UIAlertController(
               title: "Please add at least 1 step and ingredient",
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
            if (notEmptyIngredients > 0){
                let vc = storyboard?.instantiateViewController(identifier: "FinishPostViewController") as! FinishPostViewController
                
                vc.postID = self.postID!
                vc.ingredientList = ingredientItemList
                self.show(vc, sender: self)
            } else {
               let alert2 = UIAlertController(
                   title: "Please add at least 1 step AND ingredient",
                   message: "",
                   preferredStyle: .alert
               )
                
               alert2.addAction(
                   UIAlertAction(
                       title: "OK",
                       style: .default,
                       handler: nil)
               )
            
               self.present(alert2, animated: true, completion: nil)
                
               return
            }

        }
    }
    
    
    @IBAction func cancelCreatePost(_ sender: Any) {
        postsDataManager.deletePost(postID!)
        IngredientsDataManager.deleteIngredientByPost(ingredients: ingredientItemList)
        let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
        self.show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ingredientTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CreatePost1ViewController") as! CreatePost1ViewController
        print("-.-\(self.postID!)")
        vc.loadSpecificPost(id: self.postID!)
        vc.postExists(id: self.postID!)
        vc.newID = self.postID!
        self.show(vc, sender: self)
    }
}

