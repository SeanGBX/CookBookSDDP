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
    
    let currentUser = Sender(photoURL:"default", senderId: "self", displayName: "Me")
    
    var otherUser = Sender(photoURL: "", senderId: "other", displayName: "")
    
    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isNewConversation{
            otherUser.displayName = convItems!.otherUserName
            otherUser.photoURL = convItems!.imageName
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
                print(i["message"]!)
                messages.append(Message(sender: currentUser, messageId: "", sentDate: Date(), kind: .text(i["message"]!)))
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
        self.navigationItem.title = convItems?.otherUserName
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func fetchChat(){
        chatDataManager.loadSpecificChat(convItems!.otherUserId){
            convListFromFirestore in

            self.convItems = convListFromFirestore
            for i in convListFromFirestore.messages{
                print(i["message"])
            }
            
        }
        self.viewDidLoad()
    }
}

extension FriendDetailViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        print("Sending: \(text)")
        
        if isNewConversation {
            let message =  Message(sender: currentUser, messageId: createMessageId()!, sentDate: Date(), kind: .text(text))
            chatDataManager.init().createNewConversation(with: friendList!.friendId, friend: friendList!, firstMessage: message, textMessage: text, completion: {success in
                if success {
                    print("Message Sent")

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
                "message": text
            ])
            messages.append(Message(
                sender: currentUser,
                messageId: "\(messageList.count)",
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
        let newIdentifier = "\(friendList?.friendId)_CurrentUserId_\(dateString)"
        print(newIdentifier)
        return newIdentifier
    }
}
