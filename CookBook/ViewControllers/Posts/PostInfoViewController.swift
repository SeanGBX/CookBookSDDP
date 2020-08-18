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

//intrinsic table for step autogrow
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

//intrinsic table for ingredient autogrow
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

//get segment from postvc protocol
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
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var goToProfileButton: UIButton!
    
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
    
    var isFromProfile = ""
    var isFromOtherProfile: Posts? = nil
    
    var isMessage = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadIngredients()
        loadSteps()
        loadLikes(id: postItem!.postId)
        loadHealthy(id: postItem!.postId)
        loadUserLikes(id: postItem!.postId)
        loadUserHealthy(id: postItem!.postId)
        userImage.layer.cornerRadius =  userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        
        self.navigationItem.setHidesBackButton(true, animated: true);
    }
    
    //load post info by post id
    func loadSpecificPost(){
        postsDataManager.loadSpecificPost(postItem!.postId){
            post in
            self.selectedPost = post
            for i in self.selectedPost{
                commentDataManager.loadPostComments(self.postItem!.postId, onComplete: {
                    comment in
                    self.postInfoLCH.text = "\(i.likes) likes, \(comment.count) comment(s), \(i.healthy) users find this healthy"
                })
            }
        }
    }
    
    //set table height for autogrow
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.ingredientTableConstraints?.constant = self.ingredientTable.intrinsicContentSize.height
        self.stepTableConstraints?.constant = self.stepTable.intrinsicContentSize.height
    }
    
    //load like count
    func loadLikes(id: String){
        likePostDataManager.loadLikesByPost(id){
            likeList in
            self.likeList = likeList
        }
    }
    
    //load healthy count
    func loadHealthy(id: String){
        healthyPostDataManager.loadHealthyByPost(id){
            healthyList in
            self.healthyList = healthyList
        }
    }
    
    //check if user has liked post and set UI accordingly
    func loadUserLikes(id: String){
        likePostDataManager.loadUniqueLikes(id, username){
            uniqueLikeList in
            self.userLikes = uniqueLikeList
            if (self.userLikes.count > 0) {
                self.likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48"), for: .normal)
            }
        }
    }
    
    //check if user has marked post as healthy and set UI
    func loadUserHealthy(id: String){
        healthyPostDataManager.loadUniqueHealthy(id, username){
            uniqueHealthyList in
            self.userHealthy = uniqueHealthyList
            if (self.userHealthy.count > 0){
                self.healthyButton.setImage(#imageLiteral(resourceName: "icons8-kawaii-broccoli-50-2"), for: .normal)
            }
        }
    }
    
    //load ingredient for post
    func loadIngredients(){
        IngredientsDataManager.loadCompleteIngredients(postItem!.postId){
            ingredientFromFirestore in
            self.ingredientList = ingredientFromFirestore
            self.ingredientTable.reloadData()

        }
    }
    
    //load steps for post
    func loadSteps(){
        IngredientsDataManager.loadOnlySteps(postItem!.postId){
            stepFromFirestore in
            self.stepList = stepFromFirestore
            self.stepTable.reloadData()

        }
    }
    
    //set data on view appear based on post
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
        
        //get profile info from poster UID
        profileDataManager.loadProfile(postItem!.username){
            user in
            self.userList = user
            print(self.postItem!.username)
            for i in self.userList{
                self.goToProfileButton.setTitle(i.displayName, for: .normal)
                self.userImage.kf.setImage(with: URL(string: i.imageName), placeholder: UIImage(named: "DefaultProfile"))
            }
        }
        
        postInfoRecipeName.text = postItem?.recipeName
        profileDataManager.loadProfile(postItem!.username){
            user in
            self.userList = user
            for i in self.userList{
                self.goToProfileButton.setTitle(i.displayName, for: .normal)
            }
        }
        //load comment count
        commentDataManager.loadPostComments(postItem!.postId, onComplete: {
            comment in
            self.postInfoLCH.text = "\(self.postItem!.likes) likes, \(comment.count) comment(s), \(self.postItem!.healthy) users find this healthy"
        })
        postInfoTags.text = "\(postItem!.tagBudget), \(postItem!.tagStyle), \(postItem!.tagPrep)"
        
        //set navigation title to name of recipe
        self.navigationItem.title = postItem?.recipeName
    }

    //set number of rows in section based on table
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == ingredientTable) {
            return ingredientList.count
        } else if (tableView == stepTable) {
            return stepList.count
        } else {
            return 0
        }
    }
    
    //set step and ingredient data based on table
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
    
    //go to comments
    @IBAction func postInfoCommentClick(_ sender: Any) {
        let vcComments = storyboard?.instantiateViewController(identifier: "CommentsViewController") as! CommentsViewController
        
        vcComments.postItem = postItem
        vcComments.fromInfo = "1"
        self.show(vcComments, sender: self)
    }
    
    @IBAction func postInfoLikeClick(_ sender: Any) {
        likePostItem = LikePost(postId: postItem!.postId, username: username, budget: postItem!.tagBudget, prepTime: postItem!.tagPrep, cookStyle: postItem!.tagStyle)
        //if user has not liked post, add like and change ui
        if (userLikes.count == 0) {
            likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48"), for: .normal)
            likePostDataManager.insertLike(likePostItem!)
            postsDataManager.insertPostLike(postItem!.postId){
                self.loadSpecificPost()
            }
        }
        
            //if user has liked post delete like and change ui
        else if (userLikes.count > 0) {
            likeButton.setImage(#imageLiteral(resourceName: "icons8-love-48-2"), for: .normal)
            likePostDataManager.deleteLike(userLikes)
            postsDataManager.deletePostLike(postItem!.postId){
                self.loadSpecificPost()
            }
        }
        loadUserLikes(id: postItem!.postId)
    }
    
    //repeat like logic for ingredinets
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
    
    //deselect row ui
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == ingredientTable{
            ingredientTable.deselectRow(at: indexPath, animated: true)
        } else {
            stepTable.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //custom back button
    @IBAction func backButtonClicked(_ sender: Any) {
        if (isCuisine != "") {
            let vc = UIStoryboard(name: "Recipes", bundle: nil).instantiateViewController(identifier: "RecipeViewController") as! RecipeViewController
            vc.chosenCuisine = isCuisine
            vc.budget = isBudget
            vc.prepTime = isPrepTime
            vc.cuisineStyle = isMealtype
            self.show(vc, sender: self)
            
        } else if (isFromProfile != ""){
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(identifier: "Profile") as! ProfileViewController
            self.show(vc, sender: self)
        } else if (isMessage != ""){
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
            vc.loadRecommend()
            self.show(vc, sender: self)
        }
    }
    
    //share
    private func createNewConversation(result: Profile, postId: String){
        let vc = FriendDetailViewController()
        var resultconv : Conversations?
        vc.followingList = result
        vc.navigationItem.largeTitleDisplayMode = .never
        
        chatDataManager.loadSpecificChat(result.UID, username){
            specificConv in
            resultconv = specificConv
            
            
        }
        chatDataManager.findSpecificChat(result.UID, username){
            isSuccessful in
            if isSuccessful{
                vc.isNewConversation = false
                vc.convItems = resultconv
                vc.isSharing = true
                vc.shareString = postId
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                vc.isNewConversation = true
                vc.isSharing = true
                vc.shareString = postId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    //show more options
    @IBAction func moreOptionButton(_ sender: Any) {
        let alert = UIAlertController(
               title: "Actions",
               message: "",
               preferredStyle: .alert
           )
            
           alert.addAction(
               UIAlertAction(
                   title: "Cancel",
                   style: .default,
                   handler: nil)
           )
        //share
            alert.addAction(
                UIAlertAction(
                    title: "Share",
                    style: .default,
                    handler: {
                        handler in
                        let vc = NewConversationViewController()
                        vc.completion = { [weak self] result in
                            self?.createNewConversation(result: result, postId: self!.postItem!.postId)
                        }
                        let navVC = UINavigationController(rootViewController: vc)
                        self.present(navVC, animated: true)
                })
            )
            
        //if current user is not poster show unfollow/follow
        if (self.username != postItem!.username){
            followDataManager.deleteFollower(self.username, targetAccountUID: postItem!.username, onComplete: {
                    unfollow in
                    if (unfollow.count > 0){
                        alert.addAction(
                            UIAlertAction(
                                title: "Unfollow",
                                style: .default,
                                handler: {
                                    handler in
                                    followDataManager.actuallyDeleteFollower(follower: unfollow)
                                    
                            })
                        )
                    } else {
                        alert.addAction(
                            UIAlertAction(
                                title: "Follow",
                                style: .default,
                                handler: {
                                    handler in
                                    var follower23 = Followers(followerAccountUID: self.username, targetAccountUID: self.postItem!.username, followerID: "0")
                                    followDataManager.insertFollower(follower23)
                                    
                            })
                        )
                    }
                })
            }
            
        //if current user is poster show delete
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
                                            //delete go to post vc and refresh page according to segue
                                            handler in
                                            postsDataManager.deletePost(self.postItem!.postId)
                                            IngredientsDataManager.deleteIngredientByPost(ingredients: ingredientItemList)
                                            let vc = self.storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
                                            if (self.delegate?.getSegmentIndex() == 0){
                                                vc.loadRecommend()
                                            } else if (self.delegate?.getSegmentIndex() == 1){
                                                vc.loadFollowerPosts()
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
    
    //go to profile page
    @IBAction func goToProfileButtonClick(_ sender: Any) {
        let profilevc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(identifier: "OthersProfile") as! OthersProfileViewController
        profilevc.otherUser = postItem!
        self.show(profilevc, sender: self)
    }
    
}
