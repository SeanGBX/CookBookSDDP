//
//  ProfileCellA.swift
//  CookBook
//
//  Created by 180725J  on 8/14/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class ProfileCellA: UITableViewCell {

    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func FollowTapped(_ sender: Any) {
    }
}
