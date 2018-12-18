//
//  ViewController.swift
//  ColllectionViewSample
//
//  Created by SHABEERALI K on 18/12/18.
//  Copyright © 2018 SHABEERALI K. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView : UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       self.tableView.register(UINib(nibName: "VideoCollectionViewContainerTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoCollectionContainerCell")
        //self.tableView.register(VideoCollectionViewContainerTableViewCell.self, forCellReuseIdentifier: "VideoCollectionContainerCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCollectionContainerCell", for: indexPath) as! VideoCollectionViewContainerTableViewCell
        
                cell.labelCategory.text = "Category"
       
        
        /*
        //displaying image
        Alamofire.request(hero.imageUrl!).responseImage { response in
            debugPrint(response)
            
            if let image = response.result.value {
                cell.heroImage.image = image
            }
        }
 */
        
        return cell
    }

}

