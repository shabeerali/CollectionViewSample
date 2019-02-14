//
//  VODCategoryTableViewCell.swift
//  ColllectionViewSample
//
//  Created by SHABEERALI K on 07/02/19.
//  Copyright © 2019 SHABEERALI K. All rights reserved.
//

import UIKit

class VODCategoryTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var labelCategory: UILabel!
     
    @IBOutlet weak var vodCategoryCollectionView: UICollectionView!
    var categoryArray : [String]?
     var categoryImageArray : [String]?

    override func awakeFromNib() {
        super.awakeFromNib()
        /*
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
         
 */
        
        self.vodCategoryCollectionView.dataSource = self
        self.vodCategoryCollectionView.delegate = self
        self.vodCategoryCollectionView.register(UINib.init(nibName: "VODCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VODCategoryCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.categoryArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VODCategoryCollectionViewCell", for: indexPath) as! VODCategoryCollectionViewCell
        
        //cell.imageView.backgroundColor = UIColor.randomColor()
        
        //displaying image
        cell.categoryLbl.text = self.categoryArray?[indexPath.row]
        let imageName = self.categoryImageArray?[indexPath.row]
        let image = UIImage(named:imageName!)
        cell.posterImgView.image = image
    
        return cell
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 2, height: 150)
    }
 */
    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let numberOfCell: CGFloat = 2   //you need to give a type as CGFloat
        let cellWidth = UIScreen.main.bounds.size.width / numberOfCell
        return CGSize(width:cellWidth, height:cellWidth)
    }
 */

    
    

    
}
