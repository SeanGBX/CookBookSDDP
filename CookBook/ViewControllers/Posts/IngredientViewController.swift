//
//  IngredientViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/16/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseStorage

//intrinsic ingredient tableView for autoHeight
final class IntrinsicIngredientTableView: UITableView {

    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

}

class IngredientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ingredientTableView: UITableView!
//    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var ingredientItemList : [IngredientSteps] = []
    var postID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        loadIngredients()
        // hide/unhide ingredients if user has posts
        if (ingredientItemList.count > 0){
//            noLabel.isHidden = true
            nextButton.isHidden = false
            
        } else {
//            noLabel.isHidden = false
            nextButton.isHidden = true
        }
    }
    
//    override func viewWillLayoutSubviews() {
//        super.updateViewConstraints()
//        self.tableHeightConstraint?.constant = self.ingredientTableView.intrinsicContentSize.height
//    }
    
    func loadIngredients(){
        //reload table data and hide/unhide next button
        IngredientsDataManager.loadIngredients(self.postID!){
            ingredientListFromFirestore in
            self.ingredientItemList = ingredientListFromFirestore
            self.ingredientTableView.reloadData()
            if (self.ingredientItemList.count > 0){
//                self.noLabel.isHidden = true
                self.nextButton.isHidden = false
            } else {
//                self.noLabel.isHidden = false
                self.nextButton.isHidden = true
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set cell info
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

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //go to ingredient info for edit and add
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
        //validaiton to ensure user has created at least one ingredient and step
        var notEmptyIngredients = 0
        
        for i in ingredientItemList{
            if (i.ingredient != ""){
                notEmptyIngredients += 1
            }
        }
        
        //validation if user has added nothing
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
            //go to finalPost vc if validation passes
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
    
    //cancel and delete post creation
    @IBAction func cancelCreatePost(_ sender: Any) {
        postsDataManager.deletePost(postID!)
        IngredientsDataManager.deleteIngredientByPost(ingredients: ingredientItemList)
        let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
        self.show(vc, sender: self)
    }
    
    //deselect row UI
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ingredientTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //custom back button to allow post edit
    @IBAction func backButtonClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CreatePost1ViewController") as! CreatePost1ViewController
        vc.loadSpecificPost(id: self.postID!)
        vc.postExists(id: self.postID!)
        vc.newID = self.postID!
        self.show(vc, sender: self)
    }
}

