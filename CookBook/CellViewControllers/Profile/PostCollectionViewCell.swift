//
//  PostCollectionViewCell.swift
//  CookBook
//
//  Created by 180725J  on 8/16/20.
//  Copyright © 2020 ITP312T3. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    static let identifier = "PostCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage){
        imageView.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PostCollectionViewCell", bundle: nil)
    }

}
