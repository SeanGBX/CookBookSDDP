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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKey")

        view.addGestureRecognizer(tap)
        
        userImage.layer.cornerRadius =  userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        loadCurrentUserImage()
        loadComments()
    }
    
    @objc func dismissKey() {
        view.endEditing(true)
    }
    
    func loadComments(){
        commentDataManager.loadUserComments(postItem!.postId, onComplete: {
            comment in
            self.postCommentList = comment
            self.commentsTable.reloadData()
            if (self.postCommentList.count != 0){
                self.noLabel.text = "\(self.postCommentList.count) comment(s)"
            }
        })
    }
    
    func loadCurrentUserImage(){
        profileDataManager.loadProfile(username){
            user in
            self.userList = user
            for i in self.userList {
                let imageRef = Storage.storage().reference(withPath: "postImages/CC789BDD-7784-4A9C-B51B-F969504A59FB.jpg")
                imageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                        return
                    }
                    if let data = data {
                        self!.userImage.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        let p = postCommentList[indexPath.row]
        profileDataManager.loadProfile(p.username){
            user in
            self.postUserList = user
            for i in self.postUserList{
                cell.commentLabel.text = p.comment
                let imageRef1 = Storage.storage().reference(withPath: "postImages/CC789BDD-7784-4A9C-B51B-F969504A59FB.jpg")
                imageRef1.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                        return
                    }
                    if let data = data {
                        cell.commentImage.image = UIImage(data: data)
                    }
                }
            }
        }
//        cell.commentLabel.text = "\(p.username)  \(p.comment)"
//        cell.commentImage.image = UIImage(named: "dunkirk")
        cell.commentImage.layer.cornerRadius =  userImage.frame.size.width / 2
        cell.commentImage.clipsToBounds = true
        return cell
        
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        if (fromInfo == "1"){
            let vc = storyboard?.instantiateViewController(identifier: "PostInfoViewController") as! PostInfoViewController
            vc.postItem = postItem!
            self.show(vc, sender: self)
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "PostViewController") as! PostViewController
            self.show(vc, sender: self)
        }
    }
    
    
    @IBAction func addCommentButton(_ sender: Any) {
        commentItem = PostComment(postId: postItem!.postId, comment: userComment.text!, username: username)
        
        commentDataManager.insertComment(commentItem!, onComplete: {
            self.loadComments()
        })
    }
    
}
