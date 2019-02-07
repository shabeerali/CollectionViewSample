//
//  CollectionViewCell.swift
//  ColllectionViewSample
//
//  Created by SHABEERALI K on 19/12/18.
//  Copyright © 2018 SHABEERALI K. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        self.layer.shadowRadius = 2.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.contentView.layer.cornerRadius = 10.0;
        
        
        self.contentView.layer.masksToBounds = true;
        
        self.layer.shadowColor = UIColor.gray.cgColor;
        self.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOpacity = 1.0;
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath;
        
    }

}
