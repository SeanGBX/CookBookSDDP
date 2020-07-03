//
//  PostViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/13/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var postList: [Posts] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadPosts()
        self.navigationItem.setHidesBackButton(true, animated: true);
    }
    
    func loadPosts(){
        postsDataManager.loadPosts(){
            postListFromFirestore in
            self.postList = postListFromFirestore
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let p = postList[indexPath.row]
        cell.recipeName.text = p.recipeName
        cell.userName.text = p.username
        cell.CLHLabel.text = "10 comments, \(p.likes) likes, \(p.healthy) users find this healthy"
        cell.tagsLabel.text = "\(p.tagBudget), \(p.tagPrep), \(p.tagStyle)"
        cell.postImage.image = UIImage(named: p.postImage)
        
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
