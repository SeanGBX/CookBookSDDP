//
//  PopupViewController.swift
//  CookBook
//
//  Created by 182558Z  on 7/26/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    @IBOutlet weak var titleBackground: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //no time to implement
    
    @IBAction func cancelAction(_ sender: Any) {
    }
    
    @IBAction func actionAction(_ sender: Any) {
    }
}
