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
    
    @IBOutlet weak var feed: FeedCollectionView!
    @IBOutlet weak var title_lb: UILabel!
    @IBOutlet weak var topbar_bg: UIImageView!
    var feedContents : [FeedContent] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        feed.registerAdvance(FeedCell.self, nib: UINib(nibName: "FeedCell", bundle: nil))
        feed.delegateFeed = self
        feed.delegateFeedLayout = self
        feed.delegateFeedTarget = self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(FeedListVC.updateFeedList), name: NSNotification.Name(rawValue: "updateFeedList"), object: nil)
    }
    
    func updateFeedList(_ notification: NSNotification) {
        if let feedContents = notification.userInfo?["FeedContents"] as? [FeedContent] , feedContents.count > 0 {
            // do something with your image
//            self.title_lb.text = "\(feedContents.count)"
//            if (feedContents.count == 1){
//                self.title_lb.text = self.title_lb.text! + feedContents[0].postDesc
//            }
            
            
            setTitleForm()
            setTopbarColor(feedContent: feedContents[0])
            self.feedContents = feedContents
            feed.reloadDataAdvance()
            
            
            
        }
    }
    
    func setTitleForm(){
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        self.title_lb.text = "รอบๆตัวคุณตอนนี้ \(hour):\(minutes)"
    }
        
    func setTopbarColor(feedContent :FeedContent){
        
        let emoString = feedContent.emo
        let emoArray = emoString.components(separatedBy: ",")
        if(emoArray.count == 2){
            var colorID = emoArray[0]
            colorID = "5"
//            self.topbar_bg.image = MappingPinEmo.shareInstace.mappingTopBar(colorID: colorID)
            
            self.feed.backgroundColor = MappingPinEmo.shareInstace.mappingBGColor(colorID: colorID)
        
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
    
    func collapsedDrawerHeight() -> CGFloat
    {
        return 180.0
    }
    
    func partialRevealDrawerHeight() -> CGFloat
    {
        return UIScreen.main.bounds.height - 100
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all // You can specify the drawer positions you support. This is the same as: [.open, .partiallyRevealed, .collapsed, .closed]
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController)
    {
        //        tableView.isScrollEnabled = drawer.drawerPosition == .open
        
        if drawer.drawerPosition != .open
        {
            //            searchBar.resignFirstResponder()
        }
    }
}
extension FeedListVC : FeedTargetHitDelegate {
    func feedHitPoint(cell: UICollectionViewCell) {
        let cell = cell as! FeedCell
        cell.playerManager.play()
    }
    func feedPassPoint(cell: UICollectionViewCell) {
        let cell = cell as! FeedCell
        cell.playerManager.pause()
    }
}
extension FeedListVC : FeedCollectionViewDelegate {
    func feedNumberOfSections (in collectionView: UICollectionView ) -> Int {
        return 1
    }
    func feedNumberOfItemsInSection(_ collectionview : UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedContents.count
    }
    func feedCellForItem(collectionview: FeedCollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FeedCell = collectionview.dequeueReusableCellAdvance(forIndexPath: indexPath)
        let item = feedContents[indexPath.item]
        cell.lb_userName.text = item.addedByUser
        cell.lb_title.text = item.postDesc
        cell.lb_time.text = timeAgoSinceDate(Date(timeIntervalSince1970: TimeInterval(item.postDttmInt)), currentDate: Date(), numericDates: true)
        cell.lb_location.text = item.place
        if item.addedByUserURL.characters.count > 0 {
            cell.img_userProfile.af_setImage(
                withURL: URL(string: item.addedByUserURL)!,
                placeholderImage:  nil, //UIImage(named: "user_profile")
                filter: AspectScaledToFillSizeWithRoundedCornersFilter(
                    size: cell.img_userProfile.frame.size,
                    radius: cell.img_userProfile.frame.size.width/2
                )
//                    ,
//                imageTransition: .crossDissolve(0.2)
            )
        }
        
        cell.playerManager.prepare(urlPath: item.mediaURL )
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
        //        self.feed.doneFetching(isAnimiated: true, shallStopFetching: true, completion: nil)
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
        return CGSize(width: contentRemainingSize.width, height: contentRemainingSize.height / 1.2)
    }
    func  feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 15
    }
}

















