//
//  chatDataManager.swift
//  CookBook
//
//  Created by Sean Gwee on 4/7/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//
import UIKit
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class chatDataManager: NSObject {
    
    static let db = Firestore.firestore()
    
    static func loadChat(onComplete: (([Friend]) -> Void)?){
        db.collection("friends").getDocuments()
            {
                (querySnapshot, err) in var friendsList : [Friend] = []
                
                if let err = err{
                    print("Error getting documents: \(err)")
                }
                else{
                    for document in querySnapshot!.documents
                    {
                        var friend = try? document.data(as: Friend.self) as! Friend
                        if friend != nil{
                            friendsList.append(friend!)
                        }
                    }
                }
                onComplete?(friendsList)
        }
    }
    
    static func loadSpecificChat(_ userId: String, onComplete: ((Conversations) -> Void)?){
        db.collection("conversations").whereField("otherUserId", isEqualTo: userId).getDocuments(){
            
            (querySnapshot, err) in
            var specificConv : Conversations?
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var conv = try? document.data(as: Conversations.self) as! Conversations
                    
                    if conv != nil{
                        specificConv = conv
                    }
                }
            }
            onComplete?(specificConv!)
        }
    }
    
    
    static func appendChat(_ conv: Conversations, _ sentmsg: [[String:String]]) {
        try? db.collection("conversations").document("currUser_\(conv.otherUserId)")
            .updateData([
                "messages" : sentmsg
                        ])
                {
                    err in
            
                    if let err = err {
                        print("Error editing document: \(err)")
                    } else {
                        print("Document successfully edited!")
                    }
                }
    }
    
    static func deleteConv(_ conv: Conversations)
    {
        
        db.collection("collections").document(conv.otherUserId).delete() {
            err in
            
            if let err = err {
                
                print("Error removing document: \(err)")	
            } else {
                
                print("Document successfully removed!")
            }
            
        }
    }
    
    
}

extension chatDataManager{
    static func loadConversations(onComplete: (([Conversations]) -> Void)?){
        db.collection("conversations").getDocuments()
            {
                (querySnapshot, err) in var convList : [Conversations] = []
                
                if let err = err{
                    print("Error getting documents: \(err)")
                }
                else{
                    for document in querySnapshot!.documents
                    {
                        var conv = try? document.data(as: Conversations.self) as! Conversations
                        if conv != nil{
                            convList.append(conv!)
                        }
                    }
                }
                onComplete?(convList)
        }
    }
    
    
    public func createNewConversation(with otherFriendId: String, friend: Friend, firstMessage: Message, textMessage: String, completion: @escaping (Bool) -> Void){
        let messageDate = firstMessage.sentDate
        let dateString = FriendDetailViewController.dateFormatter.string(from: messageDate)
        
        var message = ""
        
        switch firstMessage.kind{
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .custom(_):
            break
        }
        
        let newConversationData = Conversations(
            currUserId: "currUser", otherUserId: otherFriendId, otherUserName: friend.friendName, imageName: friend.imageName, messages: [[
                "date": dateString,
                "message": textMessage,
                "is_read": "false"]]
        )
        
        
        try? chatDataManager.db.collection("conversations")
            .document("currUser_\(otherFriendId)")
            .setData(from: newConversationData, encoder: Firestore.Encoder()) {
                err in
                if let err = err {
                    print("Error adding document: \(err)")
                    completion(false)
                } else {
                    print("Document successfully added!")
                    completion(true)
                }
        }
        
        
    }
    
    public func getAllConversation(for friendId: String, completion: @escaping (Result<String, Error>) -> Void){
        
    }
    
    public func getAllMessagesForConversation(with id: String, coompletion: @escaping (Result<String, Error>) -> Void){
        
    }
    
    public func sendMessage(to conversation: String, message:Message, completion: @escaping (Bool) -> Void){
        
    }
    
}
