//
//  PostViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/13/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

//intrinsic post table for autogrow
class IntrinsicPostTableView: UITableView {

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

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomCellLoadData, getSegment
{
    var postList: [Posts] = []
    let username: String = Auth.auth().currentUser!.uid
    var userList: [Profile] = []
    var commentList: [PostComment] = []
    var following: [Followers] = []
    var followerPosts: [Posts] = []
    
    //refresh control declare
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(allCalls), for: .valueChanged)
        return refreshControl
    }()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postScrollView: UIScrollView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        //set segmented control ui
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemIndigo]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        loadRecommend()
        //set refresher to scroll view
        postScrollView.refreshControl = refresher
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
//    override func viewWillLayoutSubviews() {
//        super.updateViewConstraints()
//        self.heightConstraint?.constant = self.tableView.intrinsicContentSize.height
//    }
    
    //set refresher function to refresh based on segment index
    @objc func allCalls(_ sender:UIRefreshControl) {
       if (segmentedControl.selectedSegmentIndex == 0){
            loadRecommend1()
       } else if (segmentedControl.selectedSegmentIndex == 1){
            loadFollowerPosts1()
       } else if (segmentedControl.selectedSegmentIndex == 2){
            loadCompletePostsByHealthy1()
       }
    }
    
    //load posts by follower
    func loadFollowerPosts(){
        var followerPostList: [Posts] = []
        followDataManager.loadFollowing(username, onComplete: {
            following in
            self.following = following
            postsDataManager.loadCompletePosts(onComplete: {
                post in
                self.followerPosts = post
                for i in self.following{
                    for j in self.followerPosts{
                        if i.targetAccountUID == j.username{
                            if !followerPostList.contains(j){
                                followerPostList.append(j)
                            }
                        }
                    }
                }
                self.postList = followerPostList
                self.tableView.reloadData()
            })
        })
    }
    
    //load posts by follower for refresher
    @objc
    func loadFollowerPosts1(){
           var followerPostList: [Posts] = []
           followDataManager.loadFollowing(username, onComplete: {
               following in
               self.following = following
               postsDataManager.loadCompletePosts(onComplete: {
                   post in
                   self.followerPosts = post
                   for i in self.following{
                       for j in self.followerPosts{
                           if i.targetAccountUID == j.username{
                               if !followerPostList.contains(j){
                                   followerPostList.append(j)
                               }
                           }
                       }
                   }
                   self.postList = followerPostList
                   self.tableView.reloadData()
                //purposeful refresher delay for UI purposes
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)){
                        self.refresher.endRefreshing()
                    }
               })
           })
       }
    
    //load recommended
    func loadRecommend(){
        
        var asianCount = 0
        var westernCount = 0
        var mexicanCount = 0
        var middleECount = 0
        var europeanCount = 0
        var africanCount = 0
        var cheapCount = 0
        var moderatePCount = 0
        var expensiveCount = 0
        var quickCount = 0
        var moderateCount = 0
        var longCount = 0
        var categoryCount = [String: Int]()
        likePostDataManager.loadLikesByUser(username, onComplete: {
            like in
//            likes = like
            //load like by user, add to tag counter if user has liked a post with tag
            for i in like {
                if i.cookStyle.lowercased() == "asian"{
                    asianCount += 1
                }
                if i.cookStyle.lowercased() == "western"{
                    westernCount += 1
                }
                if i.cookStyle.lowercased() == "mexican"{
                    mexicanCount += 1
                }
                if i.cookStyle.lowercased() == "middle-eastern"{
                    middleECount += 1
                }
                if i.cookStyle.lowercased() == "european"{
                    europeanCount += 1
                }
                if i.cookStyle.lowercased() == "african"{
                    africanCount += 1
                }
                if i.budget.lowercased() == "cheap"{
                    cheapCount += 1
                }
                if i.budget.lowercased() == "moderately-priced"{
                    moderatePCount += 1
                }
                if i.budget.lowercased() == "expensive"{
                    expensiveCount += 1
                }
                if i.prepTime.lowercased() == "quick"{
                    quickCount += 1
                }
                if i.prepTime.lowercased() == "moderate"{
                    moderateCount += 1
                }
                if i.prepTime.lowercased() == "long"{
                    longCount += 1
                }
            }
            //place fields with respective counts into dictionary
            categoryCount["Asian"] = asianCount
            categoryCount["Western"] = westernCount
            categoryCount["Mexican"] = mexicanCount
            categoryCount["Middle-Eastern"] = middleECount
            categoryCount["European"] = europeanCount
            categoryCount["African"] = africanCount
            categoryCount["Cheap"] = cheapCount
            categoryCount["Moderately-Priced"] = moderatePCount
            categoryCount["Expensive"] = expensiveCount
            categoryCount["Quick"] = quickCount
            categoryCount["Moderate"] = moderateCount
            categoryCount["Long"] = longCount
            //order dictionary based on descending count
            var sortedCount = categoryCount.sorted { $0.1 > $1.1 }
            //create list and append field names in order of like count
            var recommendFields: [String] = []
            for i in sortedCount{
                recommendFields.append(i.key)
            }
            var recommendedPosts: [Posts] = []
            //append posts into list in order of field from sorted list
            postsDataManager.loadCompletePosts(){
                postListFromFirestore in
                var list = postListFromFirestore
                for c in recommendFields{
                     for p in list{
                        if p.tagBudget == c || p.tagStyle == c || p.tagPrep == c {
                            if !recommendedPosts.contains(p){
                                recommendedPosts.append(p)
                            }
                        }
                    }
                }
                //refresh and set post list to sorted posts
                self.postList = recommendedPosts
                self.tableView.reloadData()
            }
        })
    }
    
    //load recommend for refresher
    @objc
    func loadRecommend1(){
            
            var asianCount = 0
            var westernCount = 0
            var mexicanCount = 0
            var middleECount = 0
            var europeanCount = 0
            var africanCount = 0
            var cheapCount = 0
            var moderatePCount = 0
            var expensiveCount = 0
            var quickCount = 0
            var moderateCount = 0
            var longCount = 0
            var categoryCount = [String: Int]()
            likePostDataManager.loadLikesByUser(username, onComplete: {
                like in
                for i in like {
                    if i.cookStyle.lowercased() == "asian"{
                        asianCount += 1
                    }
                    if i.cookStyle.lowercased() == "western"{
                        westernCount += 1
                    }
                    if i.cookStyle.lowercased() == "mexican"{
                        mexicanCount += 1
                    }
                    if i.cookStyle.lowercased() == "middle-eastern"{
                        middleECount += 1
                    }
                    if i.cookStyle.lowercased() == "european"{
                        europeanCount += 1
                    }
                    if i.cookStyle.lowercased() == "african"{
                        africanCount += 1
                    }
                    if i.budget.lowercased() == "cheap"{
                        cheapCount += 1
                    }
                    if i.budget.lowercased() == "moderately-priced"{
                        moderatePCount += 1
                    }
                    if i.budget.lowercased() == "expensive"{
                        expensiveCount += 1
                    }
                    if i.prepTime.lowercased() == "quick"{
                        quickCount += 1
                    }
                    if i.prepTime.lowercased() == "moderate"{
                        moderateCount += 1
                    }
                    if i.prepTime.lowercased() == "long"{
                        longCount += 1
                    }
                }
                
                categoryCount["Asian"] = asianCount
                categoryCount["Western"] = westernCount
                categoryCount["Mexican"] = mexicanCount
                categoryCount["Middle-Eastern"] = middleECount
                categoryCount["European"] = europeanCount
                categoryCount["African"] = africanCount
                categoryCount["Cheap"] = cheapCount
                categoryCount["Moderately-Priced"] = moderatePCount
                categoryCount["Expensive"] = expensiveCount
                categoryCount["Quick"] = quickCount
                categoryCount["Moderate"] = moderateCount
                categoryCount["Long"] = longCount
                var sortedCount = categoryCount.sorted { $0.1 > $1.1 }
                var recommendFields: [String] = []
                for i in sortedCount{
                    recommendFields.append(i.key)
                }
                var recommendedPosts: [Posts] = []
                postsDataManager.loadCompletePosts(){
                    postListFromFirestore in
                    var list = postListFromFirestore
                    for c in recommendFields{
                         for p in list{
                            if p.tagBudget == c || p.tagStyle == c || p.tagPrep == c {
                                if !recommendedPosts.contains(p){
                                    recommendedPosts.append(p)
                                }
                            }
                        }
                    }
                    self.postList = recommendedPosts
                    self.tableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)){
                        self.refresher.endRefreshing()
                    }
                }
            })
        }
    
    //load all complete posts
    func loadCompletePosts(){
        postsDataManager.loadCompletePosts(){
            postListFromFirestore in
            self.postList = postListFromFirestore
            self.tableView.reloadData()
        }
    }
    
    //load posts order by healthy
    func loadCompletePostsByHealthy(){
        postsDataManager.loadCompletePostsByHealthy(){
            postListFromFirestore in
            self.postList = postListFromFirestore
            self.tableView.reloadData()
        }
    }
    
    //load all complete posts for refresher
    @objc
    func loadCompletePosts1(){
        postsDataManager.loadCompletePosts(){
            postListFromFirestore in
            self.postList = postListFromFirestore
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)){
                self.refresher.endRefreshing()
            }
        }
    }
    
    //load posts order by healthy for refresher
    @objc
    func loadCompletePostsByHealthy1(){
        postsDataManager.loadCompletePostsByHealthy(){
            postListFromFirestore in
            self.postList = postListFromFirestore
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)){
                self.refresher.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    //set data in post cells based on index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let p = postList[indexPath.row]
        print("\(indexPath.row)")
        cell.recipeName.text = p.recipeName
        //retrieve profile info
        profileDataManager.loadProfile(p.username){
            user in
            self.userList = user
            for i in self.userList{
                cell.goToProfileButton.setTitle(i.displayName, for: .normal)
                cell.userImage.kf.setImage(with: URL(string: i.imageName), placeholder: UIImage(named: "DefaultProfile"))
            }
        }
        //load post comments and set first 2 comments
        commentDataManager.loadPostComments(p.postId, onComplete: {
            comment in
            self.commentList = comment
            cell.CLHLabel.text = "\(p.likes) likes, \(comment.count) comment(s), \(p.healthy) users find this healthy"
            if (self.commentList.count > 0){
                cell.comment1Text.text = comment[0].comment
                if (self.commentList.count > 1) {
                    cell.comment2Text.text = comment[1].comment
                } else {
                    cell.comment2Text.text = ""
                }
            } else {
                cell.comment1Text.text = "No comments"
                cell.comment2Text.text = ""
            }
        })
        cell.tagsLabel.text = "\(p.tagBudget), \(p.tagPrep), \(p.tagStyle)"
        cell.postID = p.postId
        cell.postItem = p
        cell.delegate = self
        
        let imageRef = Storage.storage().reference(withPath: p.postImage)
        imageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            if let data = data {
                cell.postImage.image = UIImage(data: data)
            }
        }
        
        //change ui and count of likes
        cell.loadCell()
        
        
        return cell
    }
    
    //go to respective post based on cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ViewPostInfo"){
            let PostInfoViewController = segue.destination as! PostInfoViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            
            if(myIndexPath != nil){
                let post = postList[myIndexPath!.row]
                PostInfoViewController.postItem = post
            }
        }
    }
    
    //deselect row ui
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //refresh page for segment control switch
    @IBAction func segmentedControlSwitch(_ sender: Any) {
        if (segmentedControl.selectedSegmentIndex == 0){
            loadRecommend()
        } else if (segmentedControl.selectedSegmentIndex == 1){
             loadFollowerPosts()
        } else if (segmentedControl.selectedSegmentIndex == 2){
            loadCompletePostsByHealthy()
        }
    }
    
    //share to messages
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
                let navVC = UINavigationController(rootViewController: vc)
                self.present(navVC, animated: true)
            }
            else{
                vc.isNewConversation = true
                vc.isSharing = true
                vc.shareString = postId
                let navVC = UINavigationController(rootViewController: vc)
                self.present(navVC, animated: true)
            }
        }
        
    }
    
    //show alert, same code as postInfo with retrieved data from cell
    func showAlert(_ id: String, _ username1: String, _ postId: String){
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
        
        alert.addAction(
            UIAlertAction(
                title: "Share",
                style: .default,
                handler: {
                    handler in
                    let vc = NewConversationViewController()
                    vc.completion = { [weak self] result in
                        self?.createNewConversation(result: result, postId: postId)
                    }
                    let navVC = UINavigationController(rootViewController: vc)
                    self.present(navVC, animated: true)
            })
        )
        
        
        if (self.username != username1){
            followDataManager.deleteFollower(self.username, targetAccountUID: username1, onComplete: {
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
                                var follower23 = Followers(followerAccountUID: self.username, targetAccountUID: username1, followerID: "0")
                                followDataManager.insertFollower(follower23)
                                
                        })
                    )
                }
            })
        }
        
        if (username1 == username){
            IngredientsDataManager.loadIngredients(id, onComplete: {
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
                                        postsDataManager.deletePost(id)
                                        IngredientsDataManager.deleteIngredientByPost(ingredients: ingredientItemList)
                                        if (self.segmentedControl.selectedSegmentIndex == 0){
                                            self.loadRecommend()
                                        } else if (self.segmentedControl.selectedSegmentIndex == 1){
                                            self.loadFollowerPosts()
                                        } else if(self.segmentedControl.selectedSegmentIndex == 2){
                                            self.loadCompletePostsByHealthy()
                                        }
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
    
    //get segment index
    func getSegmentIndex() -> Int{
        return segmentedControl.selectedSegmentIndex
    }
    
    //go to post comments
    func moveToComments(postItem: Posts){
        let vcComments = storyboard?.instantiateViewController(identifier: "CommentsViewController") as! CommentsViewController
        
        vcComments.postItem = postItem
        self.show(vcComments, sender: self)
    }
    
    //go to post profile
    func moveToProfile(pos: Posts){
        let profilevc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(identifier: "OthersProfile") as! OthersProfileViewController
        profilevc.otherUser = pos
        self.show(profilevc, sender: self)
    }
}
