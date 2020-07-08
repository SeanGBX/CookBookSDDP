//
//  FriendDetailViewController.swift
//  CookBookSDDP
//
//  Created by Sean Gwee on 27/6/20.
//  Copyright © 2020 Sean Gwee. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType {
    var photoURL: String
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
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    public var isNewConversation = false
    
    var friendItem : Friend?
    
    let currentUser = Sender(photoURL:"default", senderId: "self", displayName: "Me")
    
    var otherUser = Sender(photoURL: "", senderId: "other", displayName: "")
    
    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otherUser.displayName = friendItem!.friendName
        otherUser.photoURL = friendItem!.imageName
        
        if !isNewConversation{
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
        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
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

extension FriendDetailViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        print("Sending: \(text)")
        
        if isNewConversation {
            let message =  Message(sender: currentUser, messageId: createMessageId()!, sentDate: Date(), kind: .text(text))
            chatDataManager.init().createNewConversation(with: friendItem!.friendId, firstMessage: message, completion: {success in
                if success {
                print("Message Sent")
                }
                else{
                print("Failed to send")
                }
            })
        }
        else{
            
        }
    }
    
    private func createMessageId() -> String? {
       
        guard let currentId = friendItem?.friendId else {
            return nil
        }
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(friendItem?.friendId)_CurrentUserId_\(dateString)"
        print(dateString)
        return newIdentifier
    }
}
