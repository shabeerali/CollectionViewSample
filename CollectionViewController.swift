// Copyright 2017 Brightec
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

class CollectionViewController: UIViewController {

    let programCellIdentifier = "EPGProgramCellIdentifier"
    let timerCellIdentifier = "EPGTimerCellIdentifier"
    let channelCellIdentifier = "EPGChannelCellIdentifier"
    var timeArray:[String]  = []
    var dateUtil = DateUtils()
    @IBOutlet weak var collectionView: UICollectionView!
    var channels:[Channel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.channels = Channel.channels()
        timeArray = dateUtil.thirtyMinTimeArray()

        collectionView.register(UINib(nibName: "EPGProgramCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: programCellIdentifier)
        collectionView.register(UINib(nibName: "EPGTimerCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: timerCellIdentifier)
        collectionView.register(UINib(nibName: "EPGChannelCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: channelCellIdentifier)
    }

}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let channels = channels else { return 0}
        return channels.count+1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(section == 0){
            return timeArray.count + 1
        }
        else{
            
        guard let channel = channels?[section-1], let programs = channel.programs else { return 0 }
            return programs.count+1
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable force_cast
      
        if indexPath.section == 0 {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: timerCellIdentifier,
                                                          for: indexPath) as! EPGTimerCollectionViewCell
            if indexPath.row != 0 {
                cell.timeLabel.text = timeArray[ indexPath.row  - 1]
            } else {
                cell.timeLabel.text = "Friday"//getDayForTime(minSectionFromTime: indexPath.row)
            }
            self.applyStyleForCollectionViewCellinIndexPath(cell: cell, indexPath: indexPath)
            return cell
        }
        if indexPath.section>0 && indexPath.row == 0
        {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: channelCellIdentifier ,
                                                          for: indexPath) as! EPGChannelCollectionViewCell
            
            guard let channel = channels?[indexPath.section-1] else
            {
                return cell
            }
         
            cell.channelNumberLbl.text = "\(channel.channelName!)"
            self.applyStyleForCollectionViewCellinIndexPath(cell: cell, indexPath: indexPath)
            return cell
            
        }
        else
        {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: programCellIdentifier ,
                                                        for: indexPath) as! EPGProgramCollectionViewCell
            
            guard let channel = channels?[indexPath.section-1], let programs = channel.programs else { return cell }
            
            let program = programs[indexPath.row]
            cell.contentLabel.text = "\(channel.channelName!) \(program.name!)"
            self.applyStyleForCollectionViewCellinIndexPath(cell: cell, indexPath: indexPath)
            return cell
        }
       
       
}
    
    func applyStyleForCollectionViewCellinIndexPath(cell:UICollectionViewCell,indexPath:IndexPath )
    {
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.blue.cgColor
        if indexPath.section % 2 != 0 {
            cell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.white
        }
        
    }
}
    

// MARK: - UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegate {

}
