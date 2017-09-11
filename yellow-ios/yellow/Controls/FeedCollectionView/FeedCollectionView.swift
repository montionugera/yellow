//
//  FeedCollectionView.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/5/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//
import UIKit

@objc protocol FeedCollectionViewDelegate {
    func feedNumberOfSections (in collectionView: UICollectionView ) -> Int
    func feedNumberOfItemsInSection(_ collectionview : UICollectionView, numberOfItemsInSection section: Int) -> Int
    func feedCellForItem (collectionview : FeedCollectionView,at indexPath : IndexPath ) -> UICollectionViewCell
    func feedFetchMoreDataOnScrollDown()
    func feedFetchMoreDataOnPulling()
    func feedRefresh()
    @objc optional func feed(didSelectItemat indexPath : IndexPath)
}
protocol FeedTargetHitDelegate {
    func feedHitPoint(cell : UICollectionViewCell)
    func feedPassPoint(cell : UICollectionViewCell)
}
@objc protocol FeedCollectionViewDelegateFlowLayout {
    @objc func feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,contentRemainingSize : CGSize , sizeForItemAt indexPath: IndexPath) -> CGSize
    @objc func  feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    @objc func feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
}
extension FeedCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  delegateFeedLayout.feedCollectionView(collectionView, layout: collectionViewLayout
            , contentRemainingSize: CGSize(width: self.bounds.width - inset * 2, height: self.bounds.height - inset * 2)
            , sizeForItemAt: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return delegateFeedLayout.feedCollectionView(collectionView, layout : collectionViewLayout, minimumInteritemSpacingForSectionAt  : section)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return delegateFeedLayout.feedCollectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateFeed.feed?(didSelectItemat: indexPath)
    }
}

extension FeedCollectionView : UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return delegateFeed.feedNumberOfSections(in:collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems = delegateFeed.feedNumberOfItemsInSection(collectionView,numberOfItemsInSection: section)
        return numberOfItems
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return  delegateFeed.feedCellForItem(collectionview: self, at: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return edgeInset
    }
}


@IBDesignable
class FeedCollectionView: UICollectionView {
    @IBInspectable
    var ratioHeightHit : CGFloat = 0.45
    fileprivate var currentHitIndexPath : IndexPath?
    var delegateFeed : FeedCollectionViewDelegate!
    var delegateFeedLayout : FeedCollectionViewDelegateFlowLayout!
    var delegateFeedTarget : FeedTargetHitDelegate?
    
    
    @IBInspectable
    var inset : CGFloat = 15
    
    fileprivate var edgeInset : UIEdgeInsets{ get{ return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset) }}
    
    var numberOfItems : Int = 0
    var atLeastNumberofItemToBeginFetchMore = 4
    var enableFetching = true
    var bottomInset : CGFloat = 5 {
        didSet {
            self.contentInset.bottom = bottomInset
        }
    }
    var autoFetchingWhenScroll = true
    var defaultSpacing : CGFloat = 5
    fileprivate var cellIdentifier = ""
    var shallStopFetchingMore : Bool = false
    
    fileprivate var isScrollDown = false
    fileprivate var lastestOffset = CGPoint.zero
    fileprivate let heightForViewLoadingAtBottom : CGFloat = 50
    fileprivate var isBeingFetched : Bool = false
    fileprivate var doesIntendToPullTheBottomForRefetchMoreData : Bool = false
    
    fileprivate   var previousScrollViewOffset : CGFloat = 0
    
    fileprivate var properHeightForViewLoadingAtBottom : CGFloat {
        get {
            return  heightForViewLoadingAtBottom - bottomInset <= 0 ? 0 :  heightForViewLoadingAtBottom - bottomInset
        }
    }
    func reloadAndResetPropertiesToInitilization() {
        self.reloadData()
        self.shallStopFetchingMore = false
        self.isBeingFetched = false
    }
    func registerAdvance<T: UICollectionViewCell>(_: T.Type, nib : UINib? ) where T: UICollectionViewCell {
        cellIdentifier = String(describing: T.self)
        self.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    func dequeueReusableCellAdvance<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath, withReuseIdentifier : String? = nil) -> T {
        guard let cell =  self.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            as? T else {
                fatalError("Could not dequeue cell with identifier:")
        }
        return cell
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitilization()
    }
    fileprivate var viewLoadingAtBottom : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    fileprivate var activityIndicator : UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return v
    }()
    lazy var refreshFeedControl : UIRefreshControl = {
        let v = UIRefreshControl()
        v.addTarget(self, action: #selector(FeedCollectionView.refresh(sender:)), for: UIControlEvents.valueChanged)
        return v
    }()
    func reloadDataAdvance() {
        self.reloadData()
        self.performBatchUpdates({
            //Once it done hit first cell
        }) { (isDone) in
            if self.delegateFeedTarget != nil  {
                if let cell = self.cellForItem(at: IndexPath(item: 0, section: 0 )) {
                    self.delegateFeedTarget?.feedHitPoint(cell: cell)
                }
            }
        }
    }
    func sharedInitilization()  {
        self.delegate = self
        self.dataSource = self
        viewLoadingAtBottom.backgroundColor = UIColor.clear
        viewLoadingAtBottom.addSubview(activityIndicator)
        self.addSubview(viewLoadingAtBottom)
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshFeedControl
        } else {
            self.addSubview(refreshFeedControl)
        }
    }
    func refresh(sender : AnyObject) {
        if refreshFeedControl.isRefreshing {
            delegateFeed.feedRefresh()
        }
    }
    func finishRefresh() {
        self.refreshFeedControl.endRefreshing()
    }
    
    func shallFetchMore(_ indexPath : IndexPath){
        //        print("shallFetchMore inner0 !isBeingFetched:\(!isBeingFetched) isScrollDown:\(isScrollDown) autoFetchingWhenScroll:\(autoFetchingWhenScroll) !shallStopFetchingMore:\(!shallStopFetchingMore)")
        if !isBeingFetched && isScrollDown && autoFetchingWhenScroll && !shallStopFetchingMore {
            //            print("shallFetchMore inner1 numberOfItems:\(numberOfItems) indexPathItem:\(indexPath.item)  \(numberOfItems - indexPath.item <= atLeastNumberofItemToBeginFetchMore) self.contentOffset.y:\(self.contentOffset.y) !isScrollViewPullingAtBottom:\(!isScrollViewPullingAtBottom)")
            if numberOfItems - indexPath.item <= atLeastNumberofItemToBeginFetchMore && self.contentOffset.y > 0
                //                && !isScrollViewPullingAtBottom
            {
                fetchMore(fromFunction:"shallFetchMore")
                delegateFeed.feedFetchMoreDataOnScrollDown()
            }
        }
        
    }
    func shallFetchMore(){
        //        print("shallFetchMoreInner0 !isBeingFetched:\(!isBeingFetched) isScrollDown:\(isScrollDown) autoFetchingWhenScroll:\(autoFetchingWhenScroll) !shallStopFetchingMore:\(!shallStopFetchingMore)")
        if !isBeingFetched && isScrollDown && autoFetchingWhenScroll && !shallStopFetchingMore {
            if self.contentOffset.y > self.bounds.height && (self.contentSize.height - self.contentOffset.y) <= self.bounds.height * 2 {
                fetchMore(fromFunction:"shallFetchMore")
                delegateFeed.feedFetchMoreDataOnScrollDown()
            }
        }
    }
    func shallFetchMoreAtPullingDown()  {
        //        if !isBeingFetched && isScrollDown && !shallStopFetchingMore {
        //            if isScrollViewPullingAtBottom && doesIntendToPullTheBottomForRefetchMoreData {
        //                fetchMore(fromFunction:"shallFetchMoreAtPullingDown")
        //                //                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
        //                self.delegateFeed.feedFetchMoreDataOnPulling()
        //                //                })
        //            }
        //        }
    }
    func beginRefreshWithAnimation(  completion : ((Bool) -> Void)? = nil  )  {
        self.refreshFeedControl.beginRefreshing()
        UIView.animate(withDuration: 0.33, animations: {
            self.contentOffset = CGPoint(x: 0, y: self.contentOffset.y - self.refreshFeedControl.frame.height )
        }, completion: completion)
        
    }
    fileprivate var isScrollViewPullingAtBottom : Bool {
        get {
            return self.contentOffset.y + self.frame.height > self.contentSize.height  ? true : false
        }
    }
    func doneFetching(isAnimiated : Bool = false,shallStopFetching : Bool = false,completion: (()->Void)?) {
        if isBeingFetched{
            if isAnimiated {
                UIView.animate(withDuration: 0.33, animations: {
                    self.contentInset.bottom -= self.properHeightForViewLoadingAtBottom
                }, completion: { (isDone) in
                    self.isBeingFetched = false
                    self.activityIndicator.stopAnimating()
                    self.viewLoadingAtBottom.isHidden = true
                    self.shallStopFetchingMore = shallStopFetching
                    completion?()
                })
                
            }else {
                self.contentInset.bottom -= self.properHeightForViewLoadingAtBottom
                self.isBeingFetched = false
                self.activityIndicator.stopAnimating()
                self.viewLoadingAtBottom.isHidden = true
                self.shallStopFetchingMore = shallStopFetching
                completion?()
            }
        }
    }
    func fetchMore( fromFunction : String  ,isAnimated : Bool = false) {
        self.isBeingFetched = true
        viewLoadingAtBottom.frame.size = CGSize(width: self.frame.width, height: heightForViewLoadingAtBottom)
        activityIndicator.center = CGPoint(x: viewLoadingAtBottom.bounds.width / 2, y: viewLoadingAtBottom.bounds.height / 2)
        viewLoadingAtBottom.isHidden = false
        viewLoadingAtBottom.frame.origin = CGPoint(x:0,y:self.contentSize.height)
        self.contentInset.bottom += self.properHeightForViewLoadingAtBottom
        activityIndicator.startAnimating()
    }
}
extension FeedCollectionView : UIScrollViewDelegate {
    private var centerPoint : CGPoint {
        get {
            return CGPoint(x: self.center.x, y: self.center.y + self.contentOffset.y);
        }
    }
    private var portionHitPosition : CGPoint {
        get {
            return CGPoint(x: self.center.x, y: self.bounds.height * (ratioHeightHit) + self.contentOffset.y);
        }
    }
    private  var centerCellIndexPath: IndexPath? {
        if let centerIndexPath = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
    func hitAtPortionOfTheScreenHeight() {
        let scrollSpeed = abs(self.contentOffset.y - previousScrollViewOffset)
        previousScrollViewOffset = self.contentOffset.y
        if scrollSpeed <= 25 {
            DispatchQueue.global(qos: .userInteractive).async {
                if let hitIndexPath = self.indexPathForItem(at: self.portionHitPosition) , self.currentHitIndexPath != hitIndexPath {
                    if let targetHitCell = self.cellForItem(at: hitIndexPath) {
                        DispatchQueue.main.async {
                            self.delegateFeedTarget?.feedHitPoint(cell: targetHitCell)
                        }
                    }
                    let visibleHitPassIndexPaths =  self.indexPathsForVisibleItems.filter({ (indexPath) -> Bool in
                        hitIndexPath != indexPath
                    })
                    for v in visibleHitPassIndexPaths {
                        if let targetNoHitCell = self.cellForItem(at: v) {
                            DispatchQueue.main.async {
                                self.delegateFeedTarget?.feedPassPoint(cell: targetNoHitCell)
                            }
                        }
                    }
                }
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lastestOffset = scrollView.contentOffset
        if scrollView.contentOffset.y - lastestOffset.y >= 0 {
            isScrollDown = true
        }else {
            isScrollDown = false
        }
        shallFetchMore()
        if delegateFeedTarget != nil {
            hitAtPortionOfTheScreenHeight()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.contentOffset.y + self.frame.height >=  self.contentSize.height{
            doesIntendToPullTheBottomForRefetchMoreData = true
        }else {
            doesIntendToPullTheBottomForRefetchMoreData = false
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if doesIntendToPullTheBottomForRefetchMoreData {
            shallFetchMoreAtPullingDown()
        }
    }
}

