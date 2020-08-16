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
import FirebaseAuth
import FirebaseStorage
import Kingfisher

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
    var followingList : Profile?
    
    var messageList : [[String: String]] = []
    
    var currUserName = ""				
    let currUserId = Auth.auth().currentUser!.uid
    var otherUserName = ""
    var otherUserId = ""
    
    var currUser = Sender(photoURL:"default", senderId: "curr", displayName: "")
    var otherUser = Sender(photoURL: "default", senderId: "other", displayName: "")
    
    var messages = [MessageType]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let customMenuItem = UIMenuItem(title: "Forward", action: #selector(MessageCollectionViewCell.forward(_:)))
        UIMenuController.shared.menuItems = [customMenuItem]
        profileDataManager.loadProfile(currUserId) { profiledb in
            self.currUserName = profiledb[0].displayName
        }
        
        if !isNewConversation{
            if convItems?.firstUserId != currUserId{
                otherUserName = convItems!.firstUserName
                otherUserId = convItems!.firstUserId
            }
            else{
                otherUserName = convItems!.secondUserName
                otherUserId = convItems!.secondUserId

            }
            otherUser.displayName = otherUserName
            otherUser.photoURL = "default"
            currUser.displayName = currUserName
            currUser.senderId = otherUserName
            self.navigationItem.title = otherUserName
        }
        else{
            otherUserName = followingList!.displayName
            otherUserId = followingList!.UID
            otherUser.displayName = followingList!.displayName
            otherUser.photoURL = "defaultprofile"
            currUser.displayName = currUserName
            currUser.senderId = currUserId
            self.navigationItem.title = followingList?.displayName
        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemIndigo
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationItem.standardAppearance = appearance
        setupInputButton()
        startListeningForConversation()
        
        //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKey")
        //        tap.cancelsTouchesInView = true
        //        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    private func refreshView(){
        messages = []
        var image = UIImage(named: "ryantan")
        for i in convItems!.messages{
            if i["sentBy"] == otherUserId{
                if i["is_read"] == "false"{
                     messages.append(Message(sender: otherUser, messageId: "", sentDate: Date(), kind: .text(i["message"]!)))
                }
                else{
                    messages.append(Message(
                        sender: currUser,
                        messageId: "\(messageList.count + 1)",
                        sentDate: Date(),
                        kind: .photo(Media(url: URL(string: i["message"]!), image: image!, placeholderImage: image!, size: CGSize(width: 250, height: 250)))
                    ))
                }
                
            }
            else{
                if i["is_read"] == "false"{
                     messages.append(Message(sender: currUser, messageId: "", sentDate: Date(), kind: .text(i["message"]!)))
                }
                else{
                    messages.append(Message(
                        sender: currUser,
                        messageId: "\(messageList.count + 1)",
                        sentDate: Date(),
                        kind: .photo(Media(url: URL(string: i["message"]!), image: image!, placeholderImage: image!, size: CGSize(width: 250, height: 250)))
                    ))
                }
            }
            
        }
        
        messageList = convItems!.messages
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom()
    }
    
    private func setupInputButton(){
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.onTouchUpInside{ [weak self] _ in
            self?.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    private func presentInputActionSheet(){
       let actionSheet = UIAlertController()

       actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
           let picker = UIImagePickerController()
           
           picker.sourceType = .camera
           picker.delegate = self
           picker.allowsEditing = true
           self?.present(picker, animated: true)
       }))
       actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
           let picker = UIImagePickerController()
           picker.sourceType = .photoLibrary
           picker.delegate = self
           picker.allowsEditing = true
           self?.present(picker, animated: true)
       }))
       actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       if !UIImagePickerController.isSourceTypeAvailable(.camera){
           actionSheet.actions[0].isEnabled = false
       }
       present(actionSheet, animated: true)
    }
    
    private func startListeningForConversation(){
        chatDataManager.getListenConversation(otherUserId, currUserId) { Conv in
            self.convItems = Conv
            print(Conv.messages.count)
            self.refreshView()
        }
        
       
    }
    
    
//    @objc func dismissKey() {
//        view.endEditing(true)
//        print("")
//    }
    
    func currentSender() -> SenderType {
        return currUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = message.sender
        if sender.senderId == "other"
        {
            avatarView.image = UIImage(named: "defaultprofile")
        }
        else{
            avatarView.image = UIImage(named: "ryantan")
        }
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind{
        case .photo(let photoItem):
            guard let url = photoItem.url else {
                imageView.kf.indicator?.startAnimatingView()
                return
            }
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url)
        default:
            break
        }
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
            messageList[indexPath.section] = [
                "date" : Self.dateFormatter.string(from: Date()),
                "is_read": "false",
                "message": "• Message Deleted •",
                "sentBy": currUserId
            ]
            messages[indexPath.section] = Message(sender: currUser, messageId: "\(indexPath.section)", sentDate: Date(), kind: .text("• Message Deleted •"))
            chatDataManager.appendChat(otherUserId, currUserId, messageList)
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

//Imagepicker extension
extension FriendDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        //Upload Image
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "conversations/\(randomID).jpg")
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
            let imageData = image.jpegData(compressionQuality: 0.75) else{
            return
        }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetaData){
            (downloadMetadata, error) in
            if let error = error {
                print("An error occured : \(error.localizedDescription)")
            }
            print(downloadMetadata)
            
            uploadRef.downloadURL(completion: {(url, error) in
                if let error = error{
                    print("An error occured : \(error.localizedDescription)")
                    return
                }
                if let url = url{
                    print(url.absoluteString)
                    self.messageList.append([
                                          "date" : Self.dateFormatter.string(from: Date()),
                                          "is_read": "true",
                                          "message": url.absoluteString,
                                          "sentBy": self.currUserId
                                       ])
                    chatDataManager.appendChat(self.otherUserId, self.currUserId, self.messageList)
                    self.messagesCollectionView.reloadData()
                }
            })
        }
        //Send Image
        
       
    }
}

//Text bar extension
extension FriendDetailViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        inputBar.inputTextView.text = ""
        self.messagesCollectionView.scrollToBottom()
        print("Sending: \(text)")
        
        if isNewConversation {
            let message =  Message(sender: currUser, messageId: createMessageId()!, sentDate: Date(), kind: .text(text))
            chatDataManager.init().createNewConversation(with: currUserId, following: followingList!, currUserName: currUserName, firstMessage: message, textMessage: text, completion: {
                success in
                if success {
                    print("Message Sent")
                    chatDataManager.appendChat(self.otherUserId, self.currUserId, self.messageList)

                }
                else{
                    print("Failed to send")
                }
            })
            isNewConversation = false
        }
        else{
            messageList.append([
                "date" : Self.dateFormatter.string(from: Date()),
                "is_read": "false",
                "message": text,
                "sentBy": currUserId
            ])
            messages.append(Message(
                sender: currUser,
                messageId: "\(messageList.count + 1)",
                sentDate: Date(),
                kind: .text(text)
            ))
            chatDataManager.appendChat(otherUserId, currUserId, messageList)

        }
    }
    
    private func createMessageId() -> String? {
        
        guard let currentId = followingList?.UID else {
            return nil
        }
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(followingList?.UID)_\(currUserId)_\(dateString)"
        print(newIdentifier)
        return newIdentifier
    }
}

//Long press actions extension
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
