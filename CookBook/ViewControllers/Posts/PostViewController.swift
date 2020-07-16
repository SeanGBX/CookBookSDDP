//
//  PostViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/13/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseStorage

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomCellUpdate
{
    var postList: [Posts] = []
    let username: String = "currentUser"
    
    @IBOutlet weak var tableView: UITableView!
    
    func updateTableView(){
        tableView.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadCompletePosts()
        
        self.navigationItem.setHidesBackButton(true, animated: true);
    }
    
    func loadCompletePosts(){
        postsDataManager.loadCompletePosts(){
            postListFromFirestore in
            self.postList = postListFromFirestore
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (postList.count == 0){
            var emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "There are no more posts"
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return 0
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            return postList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let p = postList[indexPath.row]
        cell.recipeName.text = p.recipeName
        cell.userName.text = p.username
        cell.CLHLabel.text = "\(p.likes) likes, 10 comments, \(p.healthy) users find this healthy"
        cell.tagsLabel.text = "\(p.tagBudget), \(p.tagPrep), \(p.tagStyle)"
        cell.postID = p.postId
        cell.postItem = p
        cell.delegate = self
        cell.loadCell()
        
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
    
}
