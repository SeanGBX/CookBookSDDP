//
//  ChatViewController.swift
//  CookBook
//
//  Created by Sean Gwee on 28/6/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var convList : [Conversations] = []
    var friendsList : [Friend] = []
    
    func loadChat(){
        chatDataManager.loadConversations(){
            convListFromFirestore in

            self.convList = convListFromFirestore
            
            self.tableView.reloadData()
        }
        chatDataManager.loadChat(){
            friendListFromFirestore in

            self.friendsList = friendListFromFirestore
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        self.navigationItem.title = "Messages"
        loadChat()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadChat()
    }
    
    
    @IBAction func didTapEditButton(_ sender: Any) {
        self.tableView.setEditing(!tableView.isEditing, animated: true)
                      if tableView.isEditing{
                       self.editButton.title = "Done"
                      }
                      else{
                       self.editButton.title = "Edit"
                      }
    }
    
       
    
    @objc private func didTapComposeButton(){
        let vc = NewConversationViewController()
        vc.completion = { [weak self] result in
            print(result.friendName)
            self?.createNewConversation(result: result)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func createNewConversation(result: Friend){
        let vc = FriendDetailViewController()
        vc.friendList = result
        vc.isNewConversation = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convList.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let conv = convList[indexPath.row]
            convList.remove(at: indexPath.row)
            chatDataManager.deleteConv(conv)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let p = convList[indexPath.row]
        let countOfList = convList[indexPath.row].messages.count
        cell.friendnameLabel.text = p.secondUserName
        cell.friendtextLabel.text = p.messages[countOfList - 1]["message"]
        cell.friendImage.image = UIImage(named: p.imageName)
        cell.friendImage.layer.borderWidth = 1
        cell.friendImage.layer.masksToBounds = false
        cell.friendImage.layer.borderColor = UIColor.black.cgColor
        cell.friendImage.layer.cornerRadius = cell.friendImage.frame.height/2
        cell.friendImage.clipsToBounds = true
        
        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?)
    {
        if(segue.identifier == "ShowFriendDetails")
        {
            let detailViewController = segue.destination as! FriendDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            if(myIndexPath != nil)
            {
                let convs = convList[myIndexPath!.row]
                detailViewController.convItems = convs
            }
        }
        
    }
    
    
}

