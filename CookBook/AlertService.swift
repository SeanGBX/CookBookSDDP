//
//  AlertService.swift
//  CookBook
//
//  Created by 182558Z  on 7/26/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class AlertService {
    
    func alert() -> PopupViewController {
        let storyboard = UIStoryboard(name: "Posts", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(identifier: "PopupViewController") as! PopupViewController
        
        return alertVC
    }
}
