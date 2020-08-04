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

class IntrinsicPostTableView: UITableView {

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

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomCellLoadData, getSegment
{
    var postList: [Posts] = []
    let username: String = Auth.auth().currentUser!.uid
    var userList: [Profile] = []
    
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
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemIndigo]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        loadRecommend()
        postScrollView.refreshControl = refresher
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.heightConstraint?.constant = self.tableView.intrinsicContentSize.height
    }
    
    @objc func allCalls(_ sender:UIRefreshControl) {
       if (segmentedControl.selectedSegmentIndex == 0){
            loadRecommend1()
       } else if (segmentedControl.selectedSegmentIndex == 1){
            loadCompletePosts1()
       } else if (segmentedControl.selectedSegmentIndex == 2){
            loadCompletePostsByHealthy1()
       }
    }
    
    func loadRecommend(){
        
        var asianCount = 0
        var westernCount = 0
        var mexicanCount = 0
        var middleECount = 0
        var cheapCount = 0
        var moderatePCount = 10
        var expensiveCount = 0
        var quickCount = 35
        var moderateCount = 60
        var longCount = 40
        var categoryCount = [String: Int]()
        likePostDataManager.loadLikesByUser(username, onComplete: {
            like in
//            likes = like
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
            }
        })
    }
    
    @objc
    func loadRecommend1(){
            
            var asianCount = 0
            var westernCount = 0
            var mexicanCount = 0
            var middleECount = 0
            var cheapCount = 0
            var moderatePCount = 10
            var expensiveCount = 0
            var quickCount = 35
            var moderateCount = 60
            var longCount = 40
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
    
    func loadCompletePosts(){
        postsDataManager.loadCompletePosts(){
            postListFromFirestore in
            self.postList = postListFromFirestore
            self.tableView.reloadData()
        }
    }
    
    func loadCompletePostsByHealthy(){
        postsDataManager.loadCompletePostsByHealthy(){
            postListFromFirestore in
            self.postList = postListFromFirestore
            self.tableView.reloadData()
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let p = postList[indexPath.row]
        print("\(indexPath.row)")
        cell.recipeName.text = p.recipeName
        profileDataManager.loadProfile(p.username){
            user in
            self.userList = user
            for i in self.userList{
                cell.userName.text = i.displayName
            }
        }
        cell.CLHLabel.text = "\(p.likes) likes, 10 comments, \(p.healthy) users find this healthy"
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
        
        cell.loadCell()
        
        return cell
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func segmentedControlSwitch(_ sender: Any) {
        if (segmentedControl.selectedSegmentIndex == 0){
            loadRecommend()
//            refresher.addTarget(self, action: #selector(loadRecommend1), for: .valueChanged)
        } else if (segmentedControl.selectedSegmentIndex == 1){
            loadCompletePosts()
//            refresher.addTarget(self, action: #selector(loadCompletePosts1), for: .valueChanged)
        } else if (segmentedControl.selectedSegmentIndex == 2){
            loadCompletePostsByHealthy()
//            refresher.addTarget(self, action: #selector(loadCompletePostsByHealthy1), for: .valueChanged)
        }
    }
    
    func refreshAccordingly(){
        
    }
    
    func showAlert(_ id: String, _ username1: String){
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
                                            self.loadCompletePosts()
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
    
    func getSegmentIndex() -> Int{
        return segmentedControl.selectedSegmentIndex
    }
}
