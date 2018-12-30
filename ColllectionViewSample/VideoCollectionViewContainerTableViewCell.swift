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
    var footerView:CustomFooterView?
    var isLoading:Bool = false
    let footerViewReuseIdentifier = "RefreshFooterView"
    
    var vods = [OnDemandVideo]()
    
    
    
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
        self.videoCollectionVIew.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewID", for: indexPath) as! CollectionViewCell
        
        //cell.imageView.backgroundColor = UIColor.randomColor()
        
         //displaying image
        let vod : OnDemandVideo = self.vods[indexPath.row]
           let imageUrl = vod.imageUrl
        Alamofire.request(imageUrl!).responseImage { response in
            
            if let image = response.result.value {
                
                cell.imageView.image = image
                cell.avatarImageView.image = nil
               
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: 60, height: 196)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    
    //compute the scroll value and play witht the threshold to get desired effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 20.0 ;
        let contentOffset = scrollView.contentOffset.x;
        let contentWidth = scrollView.contentSize.width;
        let diffWidth = contentWidth - contentOffset;
        let frameWidth = scrollView.bounds.size.width;
        var triggerThreshold  = Float((diffWidth - frameWidth))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(fabs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
        print("pullRation:\(pullRatio)")
    }
    
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x;
        let contentWidth = scrollView.contentSize.width;
        let diffWidth = contentWidth - contentOffset;
        let frameWidth = scrollView.bounds.size.width;
        let pullWidth  = fabs(diffWidth - frameWidth);
        print("pullWidth:\(pullWidth)");
        
        if pullWidth == 0.0
        {
            if (self.footerView?.isAnimatingFinal)! {
                print("load more trigger")
                self.isLoading = true
                self.footerView?.startAnimate()
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer:Timer) in
                    
                    let duplicateVods = self.vods
                  //  self.vods = self.vods + (duplicateVods as! [OnDemandVideo])
                    
                    for item in duplicateVods {
                        
                        self.vods.append(item)
                        // Do this
                    }
                
                    self.videoCollectionVIew.reloadData()
                    self.isLoading = false
                })
            }
        }
 
    }

    
}
