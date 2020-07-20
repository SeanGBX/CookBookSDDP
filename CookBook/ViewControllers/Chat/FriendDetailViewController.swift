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
    public var photoURL: String
    public var senderId: String
    public var displayName: String
}

struct Message: MessageType{
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
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
    
    var convItems : Conversations?
    
    var friendList : Friend?
    
    var messageList : [[String: String]] = []
    
    let currentUser = Sender(photoURL:"default", senderId: "self", displayName: "Sean Gwee")
    
    var otherUser = Sender(photoURL: "", senderId: "other", displayName: "")
    
    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customMenuItem = UIMenuItem(title: "Forward", action: #selector(MessageCollectionViewCell.forward(_:)))
        UIMenuController.shared.menuItems = [customMenuItem]
        if !isNewConversation{
            otherUser.displayName = convItems!.secondUserName
            otherUser.photoURL = convItems!.imageName
            self.navigationItem.title = convItems?.secondUserName
            messages.append(Message(
                sender: otherUser,
                messageId: "1",
                sentDate: Date().addingTimeInterval(-70400),
                kind: .text("Hello!")
            ))
            messages.append(Message(
                sender: otherUser,
                messageId: "2",
                sentDate: Date().addingTimeInterval(-70000),
                kind: .photo(Media(url: nil, image: UIImage(named: convItems?.imageName as! String)!, placeholderImage: UIImage(named: convItems?.imageName as! String)!, size: CGSize(width: 250, height: 250)))
            ))
            
            for i in convItems!.messages{
                print(i["sentBy"], convItems?.secondUserId)
                if i["sentBy"] == convItems?.secondUserId{
                    messages.append(Message(sender: otherUser, messageId: "", sentDate: Date(), kind: .text(i["message"]!)))
                }
                else{
                    print(i["message"]!)
                    messages.append(Message(sender: currentUser, messageId: "", sentDate: Date(), kind: .text(i["message"]!)))
                }
                
            }
            
            messageList = convItems!.messages
        }
        else{
            
            otherUser.displayName = friendList!.friendName
            otherUser.photoURL = friendList!.imageName
            self.navigationItem.title = friendList?.friendName
        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        //        tap.cancelsTouchesInView = true
        //        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.messagesCollectionView.scrollToBottom()
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)	
        print("")
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
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        if action == NSSelectorFromString("delete:") {
            return true
        }
        else if action == NSSelectorFromString("forward:"){
            return true
        }
        else {
            return super.collectionView(collectionView, canPerformAction: action, forItemAt: indexPath, withSender: sender)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        if action == NSSelectorFromString("delete:") {
            // 1.) Remove from datasource
            // insert your code here
            
            // 2.) Delete sections
            messageList[indexPath.section] = [
                "date" : Self.dateFormatter.string(from: Date()),
                "is_read": "false",
                "message": "• Message Deleted •",
                "sentBy": "seangwee"
            ]
            messages[indexPath.section] = Message(sender: currentUser, messageId: "\(indexPath.section)", sentDate: Date(), kind: .text("• Message Deleted •"))
            chatDataManager.appendChat(convItems!, messageList)
            self.messagesCollectionView.reloadData()
            print("Deleting \(messages[indexPath.section])")
        }
        else if action == NSSelectorFromString("forward:"){
            print("Forwarding")
        }
        else {
            super.collectionView(collectionView, performAction: action, forItemAt: indexPath, withSender: sender)
        }
    }
}

extension FriendDetailViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        inputBar.inputTextView.text = ""
        self.messagesCollectionView.scrollToBottom()
        print("Sending: \(text)")
        
        if isNewConversation {
            let message =  Message(sender: currentUser, messageId: createMessageId()!, sentDate: Date(), kind: .text(text))
            chatDataManager.init().createNewConversation(with: "seangwee", friend: friendList!, firstMessage: message, textMessage: text, completion: {
                success in
                if success {
                    print("Message Sent")
                    self.messages = []
                    self.messages.append(
                        Message(
                            sender: self.currentUser,
                            messageId: "\(self.messageList.count + 1)",
                            sentDate: Date(),
                            kind: .text(text)
                    ))
                    self.messagesCollectionView.reloadData()
                }
                else{
                    print("Failed to send")
                }
            })
        }
        else{
            messageList.append([
                "date" : Self.dateFormatter.string(from: Date()),
                "is_read": "false",
                "message": text,
                "sentBy": "seangwee"
            ])
            messages.append(Message(
                sender: currentUser,
                messageId: "\(messageList.count + 1)",
                sentDate: Date(),
                kind: .text(text)
            ))
            chatDataManager.appendChat(convItems!, messageList)
            self.messagesCollectionView.reloadData()
        }
    }
    
    private func createMessageId() -> String? {
        
        guard let currentId = friendList?.friendId else {
            return nil
        }
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(friendList?.friendId)_seangwee_\(dateString)"
        print(newIdentifier)
        return newIdentifier
    }
}

extension MessageCollectionViewCell {
    
    override open func delete(_ sender: Any?) {
        
        // Get the collectionView
        if let collectionView = self.superview as? UICollectionView {
            // Get indexPath
            if let indexPath = collectionView.indexPath(for: self) {
                // Trigger action
                collectionView.delegate?.collectionView?(collectionView, performAction: NSSelectorFromString("delete:"), forItemAt: indexPath, withSender: sender)
            }
        }
    }
    
    @objc func forward(_ sender: Any?) {
        
        // Get the collectionView
        if let collectionView = self.superview as? UICollectionView {
            // Get indexPath
            if let indexPath = collectionView.indexPath(for: self) {
                // Trigger action
                collectionView.delegate?.collectionView?(collectionView, performAction: #selector(MessageCollectionViewCell.forward(_:)), forItemAt: indexPath, withSender: sender)
            }
        }
    }
}
