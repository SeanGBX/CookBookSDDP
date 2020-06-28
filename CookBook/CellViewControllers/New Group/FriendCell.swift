//
//  FriendCell.swift
//  CookBookSDDP
//
//  Created by Sean Gwee on 26/6/20.
//  Copyright © 2020 Sean Gwee. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendnameLabel: UILabel!
    @IBOutlet weak var friendtextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
