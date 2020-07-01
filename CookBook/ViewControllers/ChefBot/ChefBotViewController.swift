//
//  ChefBotViewController.swift
//  CookBook
//
//  Created by ITP312Grp2 on 29/6/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import MessageKit

class ChefBotViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

    var friendItem : Friend?

    let currentUser = Sender(senderId: "self", displayName: "Me")

    var otherUser = Sender(senderId: "other", displayName: "Other")
    
    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messages.append(Message(
           sender: otherUser,
           messageId: "1",
           sentDate: Date().addingTimeInterval(-70400),
           kind: .text("Hi! You can ask me any question related to cooking or to our app and i will try my best to answer!")
       ))
        messages.append(Message(
            sender: currentUser,
            messageId: "2",
            sentDate: Date().addingTimeInterval(-60400),
            kind: .text("How many cups in a gallon?")
        ))
        messages.append(Message(
            sender: otherUser,
            messageId: "3",
            sentDate: Date().addingTimeInterval(-50400),
            kind: .text("There are 16 cups in 1 gallon")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
