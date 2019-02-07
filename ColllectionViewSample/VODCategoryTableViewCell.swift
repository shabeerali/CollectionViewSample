//
//  VODCategoryTableViewCell.swift
//  ColllectionViewSample
//
//  Created by SHABEERALI K on 07/02/19.
//  Copyright © 2019 SHABEERALI K. All rights reserved.
//

import UIKit

class VODCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vodCategoryImageVIew: UIImageView!
    @IBOutlet weak var labelCategory: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vodCategoryImageVIew.layer.cornerRadius =  10.0
        
        
        self.vodCategoryImageVIew.layer.shadowRadius = 2.0
        self.vodCategoryImageVIew.layer.shadowColor = UIColor.lightGray.cgColor
        
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true;
        self.vodCategoryImageVIew.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.vodCategoryImageVIew.layer.shadowRadius = 2.0;
        self.vodCategoryImageVIew.layer.shadowOpacity = 1.0;
        self.vodCategoryImageVIew.layer.masksToBounds = false;
        self.vodCategoryImageVIew.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath;
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
