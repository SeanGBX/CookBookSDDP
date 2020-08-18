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
import FirebaseStorage

class chatDataManager: NSObject {
    
    static let db = Firestore.firestore()
    //load all following
    static func loadChat(_ currUserId: String, _ Following: [Followers], onComplete: (([Profile]) -> Void)?){
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
                            if following!.UID != currUserId{
                                for i in Following{
                                    if following!.UID == i.targetAccountUID{
                                        followingList.append(following!)
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
                onComplete?(followingList)
        }
    }
    //finds the chat in the db
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
    //Finds the chat in the db and returns a bool
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
    
    //update messages to db
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
    
    //delete convo
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
    
    //load all convo
    static func loadConversations(_ currUserId: String, onComplete: (([Conversations]) -> Void)?){
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
                            if conv!.firstUserId == currUserId{
                                convList.append(conv!)
                            }
                            else if conv!.secondUserId == currUserId{
                                convList.append(conv!)
                            }
                        }
                    }
                }
                onComplete?(convList)
        }
    }
    
    //Creating new convo
    public func createNewConversation(with sentBy: String, following: Profile, currUserName: String, currImage: String, firstMessage: Message, msgType: String, textMessage: String, completion: @escaping (Bool) -> Void){
        let messageDate = firstMessage.sentDate
        let dateString = FriendDetailViewController.dateFormatter.string(from: messageDate)
        
        var conversationId = ""
        var firstId = ""
        var secondId = ""
        var firstName = ""
        var secondName = ""
        var firstImage = ""
        var secondImage = ""
        
        
        if following.UID < sentBy{
            print("\(following.UID)_\(sentBy)")
            conversationId = "\(following.UID)_\(sentBy)"
            firstId = following.UID
            firstName = following.displayName
            firstImage = following.imageName
            secondId = sentBy
            secondName = currUserName
            secondImage = currImage
        }
        else{
            print("\(sentBy)_\(following.UID)")
            conversationId = "\(sentBy)_\(following.UID)"
            firstId = sentBy
            firstName = currUserName
            firstImage = currImage
            secondId = following.UID
            secondName = following.displayName
            secondImage = following.imageName
        }
        
        let newConversationData = Conversations(
            firstUserId: firstId, secondUserId: secondId, firstUserName: firstName, secondUserName: secondName, firstImage: firstImage, secondImage: secondImage, messages: [[
                "date": dateString,
                "message": textMessage,
                "msgType": msgType,
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
    //Conversation listener when conversation is update it will fire
    static func getAllListenConversation(_ currUserId: String, onComplete: (([Conversations]) -> Void)?){
        db.collection("conversations").addSnapshotListener
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
                            if conv!.firstUserId == currUserId{
                                convList.append(conv!)
                            }
                            else if conv!.secondUserId == currUserId{
                                convList.append(conv!)
                            }
                        }
                    }
                }
                print("entire conv updated")
                onComplete?(convList)
        }
    }
    // get only a specific conversation when it is updated
    static func getListenConversation(_ userId: String, _ currUserId : String, onComplete: ((Conversations) -> Void)?){
    var conversationId = ""
    if userId < currUserId{
       print("\(userId)_\(currUserId)")
       conversationId = "\(userId)_\(currUserId)"
    }
    else{
       print("\(currUserId)_\(userId)")
       conversationId = "\(currUserId)_\(userId)"
    }
     chatDataManager.db.collection("conversations").document(conversationId).addSnapshotListener {
         documentSnapshot, error in
         guard let document = documentSnapshot else {
           print("Error fetching document: \(error!)")
           return
         }
         guard let data = document.data() else {
           print("Document data was empty.")
           return
         }
        var conv = try? document.data(as: Conversations.self) as! Conversations
        print("Conv was updated")
        onComplete?(conv!)
         
     }
    }
    
}
