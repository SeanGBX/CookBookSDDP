//
//  PostInfoViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/15/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class IntrinsicStepItemTableView: UITableView {

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

class IntrinsicIngredientItemTableView: UITableView {

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

protocol getSegment: class {
    func getSegmentIndex() -> Int
}

class PostInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ingredientTable: UITableView!
    @IBOutlet weak var stepTable: UITableView!
    @IBOutlet weak var postInfoImage: UIImageView!
    @IBOutlet weak var postInfoRecipeName: UILabel!
    @IBOutlet weak var postInfoUsername: UILabel!
    @IBOutlet weak var postInfoLCH: UILabel!
    @IBOutlet weak var postInfoTags: UILabel!
    @IBOutlet weak var ingredientTableConstraints: NSLayoutConstraint!
    @IBOutlet weak var stepTableConstraints: NSLayoutConstraint!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var healthyButton: UIButton!
    
    var postItem: Posts?
    var selectedPost: [Posts] = []
    var ingredientList : [IngredientSteps] = []
    var stepList : [String] = []
    var likeList : [LikePost] = []
    var healthyList : [HealthyPost] = []
    var userHealthy : [HealthyPost] = []
    var userLikes: [LikePost] = []
    var likePostItem: LikePost?
    var healthyPostItem: HealthyPost?
    let username = Auth.auth().currentUser!.uid
    var userList: [Profile] = []
    var isCuisine = ""
    var isBudget = ""
    var isPrepTime = ""
    var isMealtype = ""
    weak var delegate: getSegment?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadIngredients()
        loadSteps()
        loadLikes(id: postItem!.postId)
        loadHealthy(id: postItem!.postId)
        loadUserLikes(id: postItem!.postId)
        loadUserHealthy(id: postItem!.postId)
        
        self.navigationItem.setHidesBackButton(true, animated: true);
    }
    
    func loadSpecificPost(){
        postsDataManager.loadSpecificPost(postItem!.postId){
            post in
            self.selectedPost = post
            for i in self.selectedPost{
                self.postInfoLCH.text = "\(i.likes) likes, 3 comments, \(i.healthy) find this healthy"
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.ingredientTableConstraints?.constant = self.ingredientTable.intrinsicContentSize.height
        self.stepTableConstraints?.constant = self.stepTable.intrinsicContentSize.height
    }
    
    func loadLikes(id: String){
        likePostDataManager.loadLikesByPost(id){
            likeList in
            self.likeList = likeList
        }
    }
    
    func loadHealthy(id: String){
        healthyPostDataManager.loadHealthyByPost(id){
            healthyList in
            self.healthyList = healthyList
        }
    }
    
    func loadUserLikes(id: String){
        likePostDataManager.loadUniqueLikes(id, username){
            uniqueLikeList in
            self.userLikes = uniqueLikeList
            if (self.userLikes.count > 0) {
                self.likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48"), for: .normal)
            }
        }
    }
    
    func loadUserHealthy(id: String){
        healthyPostDataManager.loadUniqueHealthy(id, username){
            uniqueHealthyList in
            self.userHealthy = uniqueHealthyList
            if (self.userHealthy.count > 0){
                self.healthyButton.setImage(#imageLiteral(resourceName: "icons8-kawaii-broccoli-50-2"), for: .normal)
            }
        }
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
        profileDataManager.loadProfile(postItem!.username){
            user in
            self.userList = user
            for i in self.userList{
                self.postInfoUsername.text = i.displayName
            }
        }
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
            cell.stepLabel.text = "\(indexPath.row + 1).  \(s)"
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    @IBAction func postInfoCommentClick(_ sender: Any) {
    }
    
    @IBAction func postInfoLikeClick(_ sender: Any) {
        likePostItem = LikePost(postId: postItem!.postId, username: username, budget: postItem!.tagBudget, prepTime: postItem!.tagPrep, cookStyle: postItem!.tagStyle)
        if (userLikes.count == 0) {
            likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48"), for: .normal)
            likePostDataManager.insertLike(likePostItem!)
            postsDataManager.insertPostLike(postItem!.postId){
                self.loadSpecificPost()
            }
        }
        
        else if (userLikes.count > 0) {
            likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48-2"), for: .normal)
            likePostDataManager.deleteLike(userLikes)
            postsDataManager.deletePostLike(postItem!.postId){
                self.loadSpecificPost()
            }
        }
        loadUserLikes(id: postItem!.postId)
    }
    
    @IBAction func postInfoHealthyClick(_ sender: Any) {
        healthyPostItem = HealthyPost(postId: postItem!.postId, username: username)
        if (userHealthy.count == 0) {
            healthyButton.setImage(#imageLiteral(resourceName: "icons8-kawaii-broccoli-50-2"), for: .normal)
            postsDataManager.insertPostHealthy(postItem!.postId){
                self.loadSpecificPost()
            }
            healthyPostDataManager.insertHealthy(healthyPostItem!)
        }
        
        else if (userHealthy.count > 0){
            healthyButton.setImage(#imageLiteral(resourceName: "icons8-kawaii-broccoli-50"), for: .normal)
            postsDataManager.deletePostHealthy(postItem!.postId){
                self.loadSpecificPost()
            }
            healthyPostDataManager.deleteHealthy(userHealthy)
        }
        loadUserHealthy(id: postItem!.postId)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == ingredientTable{
            ingredientTable.deselectRow(at: indexPath, animated: true)
        } else {
            stepTable.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        if (isCuisine != "") {
            let vc = UIStoryboard(name: "Recipes", bundle: nil).instantiateViewController(identifier: "RecipeViewController") as! RecipeViewController
            vc.chosenCuisine = isCuisine
            vc.budget = isBudget
            vc.prepTime = isPrepTime
            vc.cuisineStyle = isMealtype
            self.show(vc, sender: self)
            
        }
        else {
            let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
            vc.loadCompletePosts()
            self.show(vc, sender: self)
        }
    }
    
    
    @IBAction func moreOptionButton(_ sender: Any) {
        let alert = UIAlertController(
               title: nil,
               message: "",
               preferredStyle: .alert
           )
            
           alert.addAction(
               UIAlertAction(
                   title: "Cancel",
                   style: .default,
                   handler: nil)
           )
            
            alert.addAction(
                UIAlertAction(
                    title: "Unfollow",
                    style: .default,
                    handler: nil)
            )
            
            if (postItem!.username == username){
                IngredientsDataManager.loadIngredients(postItem!.postId, onComplete: {
                    ingredients in
                    let ingredientItemList = ingredients
                    alert.addAction(
                        UIAlertAction(
                            title: "Delete",
                            style: .destructive,
                            handler: {
                                handler in
                                alert.dismiss(animated: true)
                                let alert1 = UIAlertController(
                                    title: "Are you sure you want to delete this post?",
                                    message: "",
                                    preferredStyle: .alert
                                )
                                
                                alert1.addAction(
                                    UIAlertAction(
                                        title: "Cancel",
                                        style: .destructive,
                                        handler: nil)
                                )
                                 
                                alert1.addAction(
                                    UIAlertAction(
                                        title: "Yes",
                                        style: .default,
                                        handler: {
                                            handler in
                                            postsDataManager.deletePost(self.postItem!.postId)
                                            IngredientsDataManager.deleteIngredientByPost(ingredients: ingredientItemList)
                                            let vc = self.storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
                                            if (self.delegate?.getSegmentIndex() == 0){
                                                vc.loadCompletePosts()
                                            } else if (self.delegate?.getSegmentIndex() == 1){
                                                vc.loadCompletePosts()
                                            } else if(self.delegate?.getSegmentIndex() == 2){
                                                vc.loadCompletePostsByHealthy()
                                            }
                                            self.show(vc, sender: self)
                                    })
                                )
                                
                                self.present(alert1, animated: true, completion: nil)
                                
                                return
                        })
                    )
                })

            }

        
           self.present(alert, animated: true, completion: nil)
            
           return
        }
    
}
