//
//  ViewController.swift
//  ColllectionViewSample
//
//  Created by SHABEERALI K on 18/12/18.
//  Copyright © 2018 SHABEERALI K. All rights reserved.
//

import UIKit


class HomeVODViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView : UITableView!
    
   
    
    
    var onDemanVideos = [OnDemandVideo]()
    
      let onDemanVideoUrls : [String] =  ["https://i.pinimg.com/170x/80/6e/86/806e86fa05945243d29f33531134b6da.jpg",
        "https://i.pinimg.com/170x/a1/83/fa/a183faac29f02fbbc968fa51f990d04c.jpg",
        "https://i.pinimg.com/170x/e4/75/1f/e4751fab0f5fc4741a9431a1850e5c72.jpg",
        
        "https://i.pinimg.com/170x/15/c2/dc/15c2dc5a0b13f4fb18051175c1f510a8.jpg",
        "https://i.pinimg.com/170x/63/42/4e/63424e551610b8349827422a8ed5fd1d.jpg",
        "https://i.pinimg.com/170x/e8/96/f6/e896f63931cd65d21f7905c3b66b3e6b.jpg",
        "https://i.pinimg.com/170x/66/b0/27/66b027589eae99deb6d92db8b80b9887.jpg",
        "https://i.pinimg.com/170x/34/1c/93/341c93029b862af1a22b64404d94156d.jpg",
        "https://i.pinimg.com/170x/31/88/4f/31884f12141ed9af8eda0521885ce32b.jpg",
        "https://i.pinimg.com/170x/60/34/f1/6034f164bbe3cade66fbc9e51b71dd6d.jpg",
        
        "https://i.pinimg.com/170x/cc/88/b6/cc88b6a351ca0ea77d74143dc72e71c5.jpg",
        "https://i.pinimg.com/170x/60/6b/ae/606bae9deff9bfe78986997a037cb73d.jpg",
        "https://i.pinimg.com/170x/e3/4c/d9/e34cd916d8eed4bf953e17eb433c8831.jpg",
        "https://i.pinimg.com/170x/ce/35/08/ce350849661626a5d94d1cf21ad3aec8.jpg",
        "https://i.pinimg.com/170x/fc/df/fc/fcdffcd580def34b6af64bf91ca27076.jpg",
        "https://i.pinimg.com/170x/87/7c/92/877c921cd619f44e10a4ed86b6aedfbf.jpg",
        "https://i.pinimg.com/170x/dc/0c/94/dc0c94360269c9cb8930c0af1710e7a5.jpg",
        
        "https://i.pinimg.com/170x/f6/b4/d0/f6b4d08b399945927e0bac39df87639f.jpg",
        "https://i.pinimg.com/170x/68/16/81/6816818807b3d16cb33e48a2cd733ca4.jpg",
        "https://i.pinimg.com/170x/a8/a0/d4/a8a0d4e1d506cdcebae2ac250eee1268.jpg",
        "https://i.pinimg.com/170x/e7/d2/42/e7d242a44c50665468845ed79699b762.jpg",
        "https://i.pinimg.com/170x/90/41/bd/9041bdf6c43c1ce3e228eb6eedefcedf.jpg",
        "https://i.pinimg.com/170x/69/01/0e/69010e52a4e9b204f56899d321c9ffa5.jpg",
        "https://i.pinimg.com/170x/67/8d/ee/678deedc11dfee4b226b855d730552e9.jpg",
        "https://i.pinimg.com/170x/99/73/0d/99730d392ced7f995cf7c8842bbd4337.jpg",
        
        "https://i.pinimg.com/170x/d6/c2/9a/d6c29a4f60c741c47c40bf509789c6a5.jpg",
        "https://i.pinimg.com/170x/2e/36/db/2e36db6734bfe73a46babfadbe7c251e.jpg",
        "https://i.pinimg.com/170x/90/5a/f4/905af449005bbf0dd8e2922135e02f43.jpg",
        "https://i.pinimg.com/170x/a4/7d/9e/a47d9e81af1d599e6dc284fbc9570f0d.jpg",
        "https://i.pinimg.com/170x/93/61/7e/93617e359bd6251aa4c11afdb62ffd4b.jpg",
        "https://i.pinimg.com/170x/6b/08/6b/6b086b7c2f6828a175f734cc073e9cbe.jpg",
        "https://i.pinimg.com/170x/81/ae/3f/81ae3fa43b51bc75081336d0fccab7c7.jpg",
        "https://i.pinimg.com/170x/6e/32/2a/6e322ad796a65accf83af8c62bc2aea9.jpg",
        "https://i.pinimg.com/170x/39/9a/0b/399a0b5cfc9e589a361eb5b98d4ec0ca.jpg",
        "https://i.pinimg.com/170x/95/c8/20/95c820d4e6fcde2dcf8145eb7e603f48.jpg"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.createOnDemandVideos()
        self.tableView.register(UINib(nibName: "VideoCollectionViewContainerTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoCollectionContainerCell")
        self.tableView.register(UINib(nibName: "VODCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "VODCategoryTableViewCell")
        
    

        //self.tableView.register(VideoCollectionViewContainerTableViewCell.self, forCellReuseIdentifier: "VideoCollectionContainerCell")
    }
    
    func createOnDemandVideos()
    {
        
        for n in 1...35 {
          
          let vod  = OnDemandVideo()
            print(n)
          vod.imageUrl = onDemanVideoUrls[n-1]
          onDemanVideos.append(vod)
     
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCollectionContainerCell", for: indexPath) as! VideoCollectionViewContainerTableViewCell
            cell.labelCategory.text = "Popular"
            cell.vods = onDemanVideos
            
           return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "VODCategoryTableViewCell", for: indexPath) as! VODCategoryTableViewCell
            
            if(indexPath.row == 1){
            
          
           
            cell.labelCategory.text = "Trending"
            
            let image = UIImage(named: "category_1.png")
            cell.vodCategoryImageVIew.image = image
            }else if(indexPath.row == 2)
            {
                cell.labelCategory.text = "Trending"
                
                let image = UIImage(named: "category_7.png")
                cell.vodCategoryImageVIew.image = image
            }
            
        
            return cell
            
        }
                
       return UITableViewCell()
    }
}



