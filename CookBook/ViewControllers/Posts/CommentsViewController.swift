//
//  CommentsViewController.swift
//  SDDPProject
//
//  Created by M07-3 on 6/15/20.
//  Copyright © 2020 NYP. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Kingfisher

//class IntrinsicCommentTableView: UITableView {
//
//    override var contentSize:CGSize {
//        didSet {
//            invalidateIntrinsicContentSize()
//        }
//    }
//
//    override var intrinsicContentSize: CGSize {
//        layoutIfNeeded()
//        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
//    }
//
//}

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userComment: UITextField!
    
    @IBOutlet weak var commentsTable: UITableView!
    
    @IBOutlet weak var noLabel: UILabel!
    
    var postCommentList : [PostComment] = []
    var commentItem: PostComment?
    var postItem: Posts?
    let username: String = Auth.auth().currentUser!.uid
    var userList: [Profile] = []
    var postUserList: [Profile] = []
    var fromInfo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //drop keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKey")

        view.addGestureRecognizer(tap)
        
        //circle image
        userImage.layer.cornerRadius =  userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        //get current user image
        loadCurrentUserImage()
        //retrieve comments
        loadComments()
    }
    
    //drop keyboard
    @objc func dismissKey() {
        view.endEditing(true)
    }
    
    //retrieve comments
    func loadComments(){
        commentDataManager.loadPostComments(postItem!.postId, onComplete: {
            comment in
            self.postCommentList = comment
            self.commentsTable.reloadData()
            //display comment count
            if (self.postCommentList.count != 0){
                self.noLabel.text = "\(self.postCommentList.count) comment(s)"
            }
        })
    }
    
    //load current user image
    func loadCurrentUserImage(){
        profileDataManager.loadProfile(username){
            user in
            self.userList = user
            for i in self.userList {
                self.userImage.kf.setImage(with: URL(string: i.imageName), placeholder: UIImage(named: "DefaultProfile"))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        let p = postCommentList[indexPath.row]
        //load profile info and set
        profileDataManager.loadProfile(p.username){
            user in
            self.postUserList = user
            for i in self.postUserList{
                cell.commentLabel.text = p.comment
                cell.commentImage.kf.setImage(with: URL(string: i.imageName), placeholder: UIImage(named: "DefaultProfile"))
            }
        }
        //circle image
        cell.commentImage.layer.cornerRadius =  userImage.frame.size.width / 2
        cell.commentImage.clipsToBounds = true
        return cell
        
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        //back to relevant vc based on previous vc
        if (fromInfo == "1"){
            let vc = storyboard?.instantiateViewController(identifier: "PostInfoViewController") as! PostInfoViewController
            vc.postItem = postItem!
            self.show(vc, sender: self)
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
            self.show(vc, sender: self)
        }
    }
    
    //add comment
    @IBAction func addCommentButton(_ sender: Any) {
        commentItem = PostComment(postId: postItem!.postId, comment: userComment.text!, username: username)
        
        commentDataManager.insertComment(commentItem!, onComplete: {
            self.loadComments()
        })
    }
    
}
