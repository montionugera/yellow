//
//  FeedListVC.swift
//  yellow
//
//  Created by ekachai limpisoot on 9/5/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
import Pulley

class FeedListVC: BaseViewController {
    
    @IBOutlet weak var feed: FeedCollectionView!
    @IBOutlet weak var test_lb: UILabel!
    var feedContents : [FeedContent] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        feed.registerAdvance(FeedCell.self, nib: UINib(nibName: "FeedCell", bundle: nil))
        feed.delegateFeed = self
        feed.delegateFeedLayout = self
        feed.delegateFeedTarget = self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(FeedListVC.updateFeedList), name: NSNotification.Name(rawValue: "updateFeedList"), object: nil)
        self.view.backgroundColor = UIColor.blue
    }
    
    func updateFeedList(_ notification: NSNotification) {
        if let feedContents = notification.userInfo?["FeedContents"] as? [FeedContent] {
            // do something with your image
            
            if (feedContents.count == 1){
                self.test_lb.text = self.test_lb.text! + feedContents[0].postDesc
            }
            self.feedContents = feedContents
            feed.reloadDataAdvance()
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
        return 108.0
    }
    
    func partialRevealDrawerHeight() -> CGFloat
    {
        return 564.0
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
        cell.playerManager.play()
    }
}

extension FeedListVC : FeedDataSourcePrefetching {
    func feed(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    func feed(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}
extension FeedListVC : FeedCollectionViewDelegate {
    func feed(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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
        cell.lb_userName.text = item.addedByUser
        cell.playerManager.prepare(urlPath: item.mediaURL)
        return cell
    }
    func feedFetchMoreDataOnScrollDown(){
        
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

















