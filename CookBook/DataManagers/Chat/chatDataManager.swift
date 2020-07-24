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
    
    static func loadChat(onComplete: (([Profile]) -> Void)?){
        db.collection("profiles").getDocuments()
            {
                (querySnapshot, err) in var followingList : [Profile] = []
                
                if let err = err{
                    print("Error getting documents: \(err)")
                }
                else{
                    for document in querySnapshot!.documents
                    {
                        var following = try? document.data(as: Profile.self) as! Profile
                        if following != nil{
                            followingList.append(following!)
                        }
                    }
                }
                onComplete?(followingList)
        }
    }
    
    static func loadSpecificChat(_ userId: String, _ currUserId : String, onComplete: ((Conversations) -> Void)?){
        var conversationId = ""
        if userId < currUserId{
           print("\(userId)_\(currUserId)")
           conversationId = "\(userId)_\(currUserId)"
        }
        else{
           print("\(currUserId)_\(userId)")
           conversationId = "\(currUserId)_\(userId)"
        }
         db.collection("conversations").document(conversationId).getDocument(){
               
               (querySnapshot, err) in
               var specificConv : Conversations?
               
               if let err = err{
                   print("Error getting documents: \(err)")
               }
               else{
                       let conv = try? querySnapshot?.data(as: Conversations.self)
                       
                       if conv != nil{
                            specificConv = conv
                            onComplete?(specificConv!)
                       }
                   }
               
           }
       }
    
    static func findSpecificChat(_ userId: String, _ currUserId: String, onComplete: ((Bool) -> Void)?){
        var conversationId = ""
        if userId < currUserId{
           print("\(userId)_\(currUserId)")
           conversationId = "\(userId)_\(currUserId)"
        }
        else{
           print("\(currUserId)_\(userId)")
           conversationId = "\(currUserId)_\(userId)"
        }
        db.collection("conversations").document(conversationId).getDocument(){
            
            (querySnapshot, err) in
            var isSuccessful : Bool = false
            
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else{
                
                let conv = try? querySnapshot?.data(as: Conversations.self)
                    
                    if conv != nil{
                        isSuccessful = true
                    }
                    
                
            }
            onComplete?(isSuccessful)
        }
    }
    
    
    static func appendChat(_ otherUserId: String, _ currUserId: String, _ sentmsg: [[String:String]]) {
        var conversationId = ""
        if otherUserId < currUserId{
           conversationId = "\(otherUserId)_\(currUserId)"
        }
        else{
           conversationId = "\(currUserId)_\(otherUserId)"
        }
        try? db.collection("conversations").document(conversationId)
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
    
    static func deleteConv(_ otherUserId: String, _ currUserId: String)
    {
        var conversationId = ""
        
        if otherUserId < currUserId{
            conversationId = "\(otherUserId)_\(currUserId)"
        }
        else{
            conversationId = "\(currUserId)_\(otherUserId)"
        }
        
        db.collection("conversations").document(conversationId).delete() {
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
    static func loadUserConversations(onComplete: (([Conversations]) -> Void)?){
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
    
    
    public func createNewConversation(with sentBy: String, following: Profile, currUserName: String, firstMessage: Message, textMessage: String, completion: @escaping (Bool) -> Void){
        let messageDate = firstMessage.sentDate
        let dateString = FriendDetailViewController.dateFormatter.string(from: messageDate)
        
        var message = ""
        var conversationId = ""
        var firstId = ""
        var secondId = ""
        var firstName = ""
        var secondName = ""
        
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
        
        if following.UID < sentBy{
            print("\(following.UID)_\(sentBy)")
            conversationId = "\(following.UID)_\(sentBy)"
            firstId = following.UID
            firstName = following.displayName
            secondId = sentBy
            secondName = currUserName
        }
        else{
            print("\(sentBy)_\(following.UID)")
            conversationId = "\(sentBy)_\(following.UID)"
            firstId = sentBy
            firstName = currUserName
            secondId = following.UID
            secondName = following.displayName
        }
        
        let newConversationData = Conversations(
            firstUserId: firstId, secondUserId: secondId, firstUserName: firstName, secondUserName: secondName, imageName: "defaultprofile", messages: [[
                "date": dateString,
                "message": textMessage,
                "is_read": "false",
                "sentBy": sentBy
                ]]
        )
        
        
        try? chatDataManager.db.collection("conversations")
            .document(conversationId)
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
    
    public func getAllConversation(for followingId: String, completion: @escaping (Result<String, Error>) -> Void){
        
    }
    
    public func getAllMessagesForConversation(with id: String, coompletion: @escaping (Result<String, Error>) -> Void){
        
    }
    
    public func sendMessage(to conversation: String, message:Message, completion: @escaping (Bool) -> Void){
        
    }
    
}
