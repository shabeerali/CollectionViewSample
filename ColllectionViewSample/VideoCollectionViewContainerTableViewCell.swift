//
//  VideoCollectionViewContainerTableViewCell.swift
//  ColllectionViewSample
//
//  Created by SHABEERALI K on 18/12/18.
//  Copyright © 2018 SHABEERALI K. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class VideoCollectionViewContainerTableViewCell:UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var videoCollectionVIew: UICollectionView!
    @IBOutlet weak var labelCategory: UILabel!
    
    var vods : [OnDemandVideo]?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 130, height: 196)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        videoCollectionVIew.collectionViewLayout = flowLayout
        
        self.videoCollectionVIew.dataSource = self
        self.videoCollectionVIew.delegate = self
        self.videoCollectionVIew.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewID")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewID", for: indexPath) as! CollectionViewCell
        
        //cell.imageView.backgroundColor = UIColor.randomColor()
        
         //displaying image
          let vod = self.vods?[indexPath.row]
           let imageUrl = vod?.imageUrl
        Alamofire.request(imageUrl!).responseImage { response in
            
            if let image = response.result.value {
                
                cell.imageView.image = image
                cell.avatarImageView.image = nil
               
            }
        }
        
        return cell
    }
    
}
