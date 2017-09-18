//
//  FeedListVC.swift
//  yellow
//
//  Created by ekachai limpisoot on 9/5/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
import AlamofireImage

class FeedListVC: BaseViewController {
    var recommendedHeightOfCell : CGFloat = 0.0
    @IBOutlet weak var backgroundViewUnderFeedView: UIView!
    @IBOutlet weak var feed: FeedCollectionView!
    @IBOutlet weak var title_lb: UILabel!
    @IBOutlet weak var topbar_bg: UIImageView!
    var feedContents : [FeedContent] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        recommendedHeightOfCell = FeedCell.getRecommendHeight()
        feed.registerAdvance(FeedCell.self, nib: UINib(nibName: "FeedCell", bundle: nil))
        feed.delegateFeed = self
        feed.delegateFeedLayout = self
        feed.delegateFeedTarget = self
        feed.dataSourceFeedPrefetching = self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(FeedListVC.updateFeedList), name: NSNotification.Name(rawValue: "updateFeedList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FeedListVC.updateFeedLike), name: NSNotification.Name(rawValue: "updateFeedLike"), object: nil)
    }
    func updateFeedList(_ notification: NSNotification) {
        if let feedContents = notification.userInfo?["FeedContents"] as? [FeedContent] , feedContents.count > 0 {
            let isUserLocation : Bool = notification.userInfo?["UserLocaton"] as! Bool
            let isFirse : Bool = notification.userInfo?["isFirse"] as! Bool
            
            if(isUserLocation == true){
                setTitleForm()
            }
            if(isFirse == false){
                setTopbarColor(feedContent: feedContents[0],isUserLocation: isUserLocation)
            }else{
                self.title_lb.isHidden = false
            }
            
            self.feedContents = feedContents
            feed.reloadDataAdvance()
        }
    }
    
    func updateFeedLike(_ notification: NSNotification) {
        if let feedContent = notification.userInfo?["FeedContent"] as? FeedContent {
            if let i = self.feedContents.index(where: { $0.key == feedContent.key }) {
                self.feedContents[i] = feedContent
                let indexPath = IndexPath(item: i, section: 0)
                if let cell : FeedCell = feed.cellForItemAdvance(indexPath: indexPath) as? FeedCell {
                    // update cell
                    cell.feedContent = feedContent
                    cell.lb_loveCount.text = String(describing: feedContent.love)
                    
                    //                    if let ff = feed {
                    //                        ff.reloadItems(at: [indexPath])
                    //                    }
                }
            }
        }
    }
    func setTitleForm(){
        self.title_lb.isHidden = true
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        self.title_lb.text = "รอบๆตัวคุณตอนนี้ \(hour):\(minutes)"
    }
    
    
    func setTopbarColor(feedContent :FeedContent , isUserLocation : Bool){
        
        let emoString = feedContent.emo
        let emoArray = emoString.components(separatedBy: ",")
        if(emoArray.count == 2){
            var colorID = emoArray[0]
            
            if(isUserLocation == true){
                colorID = "0"
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.alpha = 0.0
            }, completion: { (finish) in
                
                self.topbar_bg.image = MappingPinEmo.shareInstace.mappingTopBar(colorID: colorID)
                self.backgroundViewUnderFeedView.backgroundColor = MappingPinEmo.shareInstace.mappingBGColor(colorID: colorID)
                
                if(isUserLocation == false){
                    self.title_lb.text = feedContent.place
                }
                self.title_lb.isHidden = false
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.alpha = 1.0
                }, completion: { (finish) in
                    
                })
            })
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateFeedList"), object: nil);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension FeedListVC: PulleyDrawerViewControllerDelegate {
    func collapsedDrawerHeight() -> CGFloat{
        return 180.0
    }
    func partialRevealDrawerHeight() -> CGFloat{
        return UIScreen.main.bounds.height - 30.0
    }
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    func drawerPositionDidChange(drawer: PulleyViewController){
        if drawer.drawerPosition != .open
        {
            self.feed.isUserInteractionEnabled = false
            
            for cell in self.feed.visibleCells as! [FeedCell] {
                cell.playerManager.pause()
                cell.operation?.cancel()
            }
            
        }else{
            self.feed.isUserInteractionEnabled = true
        }
    }
}
extension FeedListVC : FeedTargetHitDelegate {
    func feedHitPoint(collectionView: FeedCollectionView, at indexPath: IndexPath) {
        if let targetCell = collectionView.cellForItemAdvance(indexPath: indexPath) as? FeedCell {
            targetCell.playerManager.play()
            let anotherCells =  collectionView.visibleCells.filter { (cell) -> Bool in
                cell != targetCell
                } as? [FeedCell]
            if let cells = anotherCells , cells.count > 0 {
                for item in cells  {
                    item.playerManager.pause()
                }
            }
        }
    }
    
    //    func feedHitPoint(cell: UICollectionViewCell) {
    //        let cell = cell as! FeedCell
    //        cell.playerManager.play()
    //    }
    //    func feedPassPoint(cell: UICollectionViewCell) {
    //        let cell = cell as! FeedCell
    //        cell.playerManager.play()
    //    }
}

extension FeedListVC : FeedDataSourcePrefetching {
    func feed(_ collectionView: FeedCollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            
        }
    }
    func feed(_ collectionView: FeedCollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            
        }
    }
}
extension FeedListVC : FeedCollectionViewDelegate {
    func feed(_ collectionView: FeedCollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let feedCell = cell as! FeedCell
        feedCell.playerManager.pause()
        feedCell.operation?.cancel()
    }
    func feedNumberOfSections (in collectionView: UICollectionView ) -> Int {
        return 1
    }
    func feedNumberOfItemsInSection(_ collectionview : UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedContents.count
    }
    func feedCellForItem(collectionview: FeedCollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FeedCell = collectionview.dequeueReusableCellAdvance(forIndexPath: indexPath)
        let item = feedContents[indexPath.item]
        cell.feedContent = item
        cell.lb_userName.text = item.addedByUserName
        cell.lb_loveCount.text = "\(item.love)"
        cell.lb_title.text = item.postDesc
        cell.lb_time.text = timeAgoSinceDate(Date(timeIntervalSince1970: TimeInterval(item.postDttmInt)), currentDate: Date(), numericDates: true)
        cell.lb_location.text = item.place
        if item.addedByUserURL.characters.count > 0 {
            cell.img_userProfile.af_setImage(
                withURL: URL(string: item.addedByUserURL)!,
                placeholderImage:  nil,
                filter: AspectScaledToFillSizeWithRoundedCornersFilter(
                    size: cell.img_userProfile.frame.size,
                    radius: cell.img_userProfile.frame.size.width/2
                )
            )
        }
        
        
        let emoString = item.emo
        let emoArray = emoString.components(separatedBy: ",")
        if(emoArray.count == 2){
            let colorID = emoArray[0]
            let emoID = emoArray[1]
            cell.img_emo.backgroundColor = MappingPinEmo.shareInstace.mappingBGColor(colorID: colorID)
            cell.img_emo.image = MappingPinEmo.shareInstace.mappingEmo(colorID: colorID, emoID: emoID)
            
        }
        
        
        let operation = BlockOperation {
            cell.playerManager.prepare(urlPath: item.mediaURL)
        }
        cell.operation = operation
        collectionview.queueLoadMedia.addOperation(operation)
        return cell
    }
    func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    
    func feedFetchMoreDataOnScrollDown(){
        self.feed.doneFetching(isAnimiated: false, shallStopFetching: true, completion: nil)
    }
    func feedFetchMoreDataOnPulling(){
        
    }
    func feedRefresh(){
        self.feed.finishRefresh()
    }
    func feed(didSelectItemat indexPath: IndexPath) {
        
    }
}
extension FeedListVC : FeedCollectionViewDelegateFlowLayout {
    func feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, contentRemainingSize: CGSize, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentRemainingSize.width, height: recommendedHeightOfCell )
    }
    func  feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 15
    }
}


