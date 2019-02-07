//
//  CustomCollectionViewLayout.swift
//  CustomCollectionLayout
//
//  Created by JOSE MARTINEZ on 15/12/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {

   // let numberOfColumns = 8
    ///var shouldPinFirstColumn = true
    //var shouldPinFirstRow = true

    var itemAttributes = [[UICollectionViewLayoutAttributes]]()
   // var itemsSize = [CGSize]()
    var itemSizeDict : NSMutableDictionary?
    var contentSize: CGSize = .zero
    let CHANNEL_SECION_COUNT = 1
    
    let RELATIVE_HOUR : TimeInterval = 400.0//(240.0)
    let ACTUAL_HOUR : TimeInterval = 3600.0
    
    var epgStartTime : Date!
    var epgEndTime : Date!
    var xPos:CGFloat = 0
    var yPos:CGFloat = 0
    //var layoutInfo : NSMutableDictionary?
  
    var totalChannelCount : Int?
    
    let weekTimeInterval : TimeInterval = (60 * 60 * 24 * 2)
    let TILE_PROGRAM_DEFAULT_WIDTH : CGFloat = 200
    let TILE_WIDTH_TIME : CGFloat = 200
    let TILE_WIDTH_CHANNEL : CGFloat = 100
    let TILE_HEIGHT : CGFloat = 70
    let TILE_HEIGHT_TIME : CGFloat = 30
    
    var channels : [Channel]?
     var timeArray:[String]  = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        
        let cal = Calendar.current
        var date = Date()
        date = cal.startOfDay(for: date)
        date = (cal as NSCalendar).date(byAdding: .day, value: -1, to: date, options: [])!
        epgStartTime = date
        epgEndTime = epgStartTime.addingTimeInterval(weekTimeInterval)
        itemSizeDict = NSMutableDictionary()
        channels = Channel.channels()
        guard let totChannels = channels?.count else
        {
            return
        }
        totalChannelCount = totChannels + CHANNEL_SECION_COUNT
        let dateUtil = DateUtils()
        timeArray = dateUtil.thirtyMinTimeArray()
        
    }

    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

        if collectionView.numberOfSections == 0 {
            return
        }

        if itemAttributes.count != collectionView.numberOfSections {
            generateItemAttributes(collectionView: collectionView)
            return
        }

        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                if section != 0 && item != 0 {
                    continue
                }

                let attributes = layoutAttributesForItem(at: IndexPath(item: item, section: section))!
                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = collectionView.contentOffset.y
                    attributes.frame = frame
                }

                if item == 0 {
                    var frame = attributes.frame
                    frame.origin.x = collectionView.contentOffset.x
                    attributes.frame = frame
                }
            }
        }

    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.section][indexPath.row]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in itemAttributes {
            let filteredArray = section.filter { obj -> Bool in
                return rect.intersects(obj.frame)
            }

            attributes.append(contentsOf: filteredArray)
        }

        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}

// MARK: - Helpers
extension CustomCollectionViewLayout {
    
    func tileSize(for program : Program) -> CGSize {
        let duartionFactor = program.duration / ACTUAL_HOUR
        //let width :CGFloat = CGFloat(duartionFactor * RELATIVE_HOUR)
        let random = Int(arc4random_uniform(2)+1)
        let width : CGFloat = 200//*CGFloat(random)
        return CGSize(width: width, height: TILE_HEIGHT)
        /*CHNG* WIDTH--> 200*/
    }
    func tileSizeForTimeBar() -> CGSize {
        
        return CGSize(width: TILE_WIDTH_TIME, height: TILE_HEIGHT_TIME)
        
    }
    func tileSizeForDay() -> CGSize {
        
        return CGSize(width: TILE_WIDTH_CHANNEL, height: TILE_HEIGHT_TIME)
        
    }
    func tileSizeForChannel() -> CGSize {
        
        return CGSize(width: TILE_WIDTH_CHANNEL, height: TILE_HEIGHT)
        
    }
    
    

    func generateItemAttributes(collectionView: UICollectionView) {
        
        if itemSizeDict?.allKeys.count == 0
        {
             calculateItemSizes()
        }
        
      ///  if  != numberOfColumns {
           
      //  }

        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0

        itemAttributes = []
        
        guard let channels = channels else { return }
        for section in 0..<channels.count {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []
            
            let channel = channels[section]
            guard let programs = channel.programs else {
               
                continue
            }

            for index in 0..<programs.count {
                
                let indexPath = IndexPath(item: index, section: section)
                let itemSize = itemSizeDict![indexPath] as! CGSize
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral

                if section == 0 && index == 0 {
                    // First cell should be on top
                    attributes.zIndex = 1024
                } else if section == 0 || index == 0 {
                    // First row/column should be above other cells
                    attributes.zIndex = 1023
                }

                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = collectionView.contentOffset.y
                    attributes.frame = frame
                }
                if index == 0 {
                    var frame = attributes.frame
                    frame.origin.x = collectionView.contentOffset.x
                    attributes.frame = frame
                }

                sectionAttributes.append(attributes)

                xOffset += itemSize.width
                column += 1

                if column == programs.count {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }

                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }

            itemAttributes.append(sectionAttributes)
        }

        if let attributes = itemAttributes.last?.last {
            contentSize = CGSize(width: contentWidth, height: attributes.frame.maxY)
        }
    }

    func calculateItemSizes() {
    
        let dayTileSize:CGSize = self.tileSizeForDay()
        let indexPath = IndexPath(item: 0, section: 0)
        itemSizeDict?[indexPath] = dayTileSize
        
        for timeIndex in 1..<timeArray.count+1
        {
            let timeTileSize:CGSize = self.tileSizeForTimeBar()
            let indexPath = IndexPath(item: timeIndex, section: 0)
            itemSizeDict?[indexPath] = timeTileSize
            
        }
        guard let channels = channels else { return }
        for channelIndex in 1..<channels.count+1
        {
            let channelTileSize:CGSize = self.tileSizeForChannel()
            let indexPath = IndexPath(item: channelIndex, section: 1)
            itemSizeDict?[indexPath] = channelTileSize
        }
        
        
        for section in 0..<channels.count{
            xPos = 0
            let channel = channels[section]
            guard let programs = channel.programs else {
                yPos += TILE_HEIGHT
                continue
            }
            for index in 0..<programs.count {
                let program = programs[index]
                let tileSize = self.tileSize(for: program)
                //let frame = CGRect(x: xPos, y: yPos, width: tileSize.width, height: tileSize.height)
                //let rectString = NSStringFromCGRect(frame)
                let indexPath = IndexPath(item: index, section: section)
                //framesInfo?[indexPath] = rectString
                itemSizeDict?[indexPath] = tileSize
                xPos = xPos+tileSize.width
               // itemsSize[index] = tileSize
            }
            yPos += TILE_HEIGHT
        }
        
      /*
        for index in 0..<numberOfColumns {
            itemsSize.append(sizeForItemWithColumnIndex(index))
        }
 */
    }

    func sizeForItemWithColumnIndex(_ columnIndex: Int) -> CGSize {
        var text: NSString

        switch columnIndex {
        case 0:
            text = "MMM-99"

        default:
            text = "Content"
        }

        let size: CGSize = text.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)])
        let width: CGFloat = size.width + 16
        return CGSize(width: width, height: 30)
    }

}
