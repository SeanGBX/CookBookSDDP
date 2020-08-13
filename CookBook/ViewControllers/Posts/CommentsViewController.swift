//
//  CommentsViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/15/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var postCommentList : [PostComment] = []
    var postItem: Posts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(postItem!.recipeName)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        let p = postCommentList[indexPath.row]
        cell.commentLabel.text = "\(p.username)  \(p.comment)"
        cell.commentImage.image = UIImage(named: "dunkirk")
        
        return cell
        
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
        self.show(vc, sender: self)
    }
    
}
