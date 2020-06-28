//
//  FriendDetailViewController.swift
//  CookBookSDDP
//
//  Created by Sean Gwee on 27/6/20.
//  Copyright © 2020 Sean Gwee. All rights reserved.
//

import UIKit
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Media: MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    
}


class FriendDetailViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{

    var friendItem : Friend?
    
    let currentUser = Sender(senderId: "self", displayName: "Me")
    
    var otherUser = Sender(senderId: "other", displayName: "")
    
    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otherUser.displayName = friendItem!.friendName
        messages.append(Message(
            sender: currentUser,
            messageId: "1",
            sentDate: Date().addingTimeInterval(-70400),
            kind: .text("Hello!")
        ))
        messages.append(Message(
                   sender: otherUser,
                   messageId: "2",
                   sentDate: Date().addingTimeInterval(-70000),
                   kind: .photo(Media(url: nil, image: UIImage(named: friendItem?.imageName as! String)!, placeholderImage: UIImage(named: friendItem?.imageName as! String)!, size: CGSize(width: 250, height: 250)))
               ))

        messages.append(Message(
            sender: otherUser,
            messageId: "3",
            sentDate: Date().addingTimeInterval(-66400),
            kind: .text(friendItem!.friendText)
        ))
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        
    }
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = friendItem?.friendName
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
