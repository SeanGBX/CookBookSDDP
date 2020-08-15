//
//  ChefBotViewController.swift
//  CookBook
//
//  Created by ITP312Grp2 on 29/6/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation
import Kommunicate
import FirebaseAuth
import JGProgressHUD

class ChefBotViewController: UIViewController{
    
//    @IBOutlet weak var messageField: UITextField!
//    @IBOutlet weak var chefBotResponse: UILabel!
//    @IBAction func sendMessage(_ sender: Any) {
//        let request = ApiAI.shared().textRequest()
//
//        if let text = self.messageField.text, text != "" {
//            request?.query = text
//        } else {
//            return
//        }
//
//        request?.setMappedCompletionBlockSuccess({ (request, response) in
//            let response = response as! AIResponse
//            if let textResponse = response.result.fulfillment.speech {
//                self.speechAndText(text: textResponse)
//            }
//        }, failure: { (request, error) in
//            print(error!)
//        })
//
//        ApiAI.shared().enqueue(request)
//        messageField.text = ""
//    }
    
    let currUser = "test"
    let currEmail = "Test@gmail.com"
    private let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Kommunicate.setup(applicationId: "30849dc39f6963dfd88f3ccac127308c")
        let kmUser = KMUser()
        kmUser.userId = currUser
        kmUser.email = currEmail
        Kommunicate.registerUser(kmUser, completion: {
            response, error in
            guard error == nil else {return}
            print(" login Success ") // You can launch the chat screen on success of login
        })
        let kmNavigationBarProxy = UINavigationBar.appearance(whenContainedInInstancesOf: [KMBaseNavigationViewController.self])
        kmNavigationBarProxy.isTranslucent = false
        kmNavigationBarProxy.barTintColor = UIColor.systemIndigo
        kmNavigationBarProxy.tintColor = UIColor.white
        kmNavigationBarProxy.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        Kommunicate.defaultConfiguration.hideFaqButtonInConversationList = true
        Kommunicate.defaultConfiguration.hideFaqButtonInConversationView = true
        Kommunicate.defaultConfiguration.chatBar.optionsToShow = .none
        KMMessageStyle.sentBubble.color = UIColor.systemGreen
    }
    
    @IBAction func startBotConvo(_ sender: Any) {
        spinner.show(in: view)
        Kommunicate.createAndShowConversation(from: self, completion: {
            error in
            self.spinner.dismiss()
            self.view.isUserInteractionEnabled = true
            if error != nil {
                print("Error while launching")
            }
        })
        
    }
//    let speechSynthesizer = AVSpeechSynthesizer()
//
//    func speechAndText(text: String) {
//        let speechUtterance = AVSpeechUtterance(string: text)
//        speechSynthesizer.speak(speechUtterance)
//        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
//            self.chefBotResponse.text = text
//        }, completion: nil)
//    }
//
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
