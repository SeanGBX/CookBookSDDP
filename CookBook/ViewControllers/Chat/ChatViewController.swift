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
    
    var friendsList : [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsList.append(Friend(
            friendName: "Ryan Tan",
            friendText: "Hello!",
            imageName: "ryantan"))
        friendsList.append(Friend(
            friendName: "Arman Khan",
            friendText: "hi!",
            imageName: "defaultprofile"))
        friendsList.append(Friend(
            friendName: "Ian Loi",
            friendText: "Hey!",
            imageName: "defaultprofile"))
        self.navigationItem.title = "Messages"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let p = friendsList[indexPath.row]
        cell.friendnameLabel.text = p.friendName
        cell.friendtextLabel.text = p.friendText
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
                let friends = friendsList[myIndexPath!.row]
                detailViewController.friendItem = friends
            }
        }
        
    }
    
    
}

