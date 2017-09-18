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
    @objc optional func feed(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func feedFetchMoreDataOnScrollDown()
    func feedFetchMoreDataOnPulling()
    func feedRefresh()
    
    @objc optional func feed(_ collectionView: FeedCollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    @objc optional func feed(didSelectItemat indexPath : IndexPath)
}
@objc protocol FeedTargetHitDelegate {
    @objc   optional func feedHitPoint(cell : UICollectionViewCell)
    @objc optional func feedPassPoint(cell : UICollectionViewCell)
    func feedHitPoint(collectionView : FeedCollectionView,at indexPath : IndexPath )
}
protocol FeedDataSourcePrefetching {
    func feed(_ collectionView: FeedCollectionView, prefetchItemsAt indexPaths: [IndexPath])
    func feed(_ collectionView: FeedCollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath])
}
@objc protocol FeedCollectionViewDelegateFlowLayout {
    @objc func feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,contentRemainingSize : CGSize , sizeForItemAt indexPath: IndexPath) -> CGSize
    @objc func  feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    @objc func feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
}
enum ScrollFeedDirection : Int  {
    case up = 0 ,
    down , none
}
extension FeedCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  delegateFeedLayout.feedCollectionView(collectionView, layout: collectionViewLayout
            , contentRemainingSize: CGSize(width: self.bounds.width - insetLeft - insetRight , height: self.bounds.height - insetTop - insetBottom )
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
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegateFeed.feed?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegateFeed.feed?(self, didEndDisplaying: cell, forItemAt: indexPath)
    }
}
@available(iOS 10, *)
extension FeedCollectionView : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        dataSourceFeedPrefetching?.feed(self, prefetchItemsAt: indexPaths)
    }
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        dataSourceFeedPrefetching?.feed(self, cancelPrefetchingForItemsAt: indexPaths)
    }
}
@IBDesignable
class FeedCollectionView: UICollectionView {

    @IBInspectable
    var ratioHeightHit : CGFloat = 0.45
    var scrollFeedDirection : ScrollFeedDirection = .none
    fileprivate var currentHitIndexPath : IndexPath?
    var delegateFeed : FeedCollectionViewDelegate!
    var delegateFeedLayout : FeedCollectionViewDelegateFlowLayout!
    var delegateFeedTarget : FeedTargetHitDelegate?
    var dataSourceFeedPrefetching : FeedDataSourcePrefetching?
    @IBInspectable
    var insetTop : CGFloat = 15
    @IBInspectable
    var insetLeft : CGFloat = 15
    @IBInspectable
    var insetBottom : CGFloat = 15
    @IBInspectable
    var insetRight : CGFloat = 15
    lazy var queueLoadMedia : OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInteractive
        q.maxConcurrentOperationCount = 4
        q.underlyingQueue =  DispatchQueue.global(qos: .userInteractive )
        return q
    }()
    fileprivate var edgeInset : UIEdgeInsets{ get{ return UIEdgeInsets(top: insetTop, left: insetLeft, bottom: insetBottom, right: insetRight) }}
    var numberOfItems : Int = 0
    var atLeastNumberofItemToBeginFetchMore = 4
    @IBInspectable
    var enableFetching : Bool = true
    var bottomInset : CGFloat = 50 {
        didSet {
            self.contentInset.bottom = bottomInset
        }
    }
    var autoFetchingWhenScroll = true
    var defaultSpacing : CGFloat = 5
    fileprivate var cellIdentifier = ""
    var shallStopFetchingMore : Bool = false
    
    //    fileprivate var isScrollDown = false
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
    func cellForItemAdvance<T : UICollectionViewCell> (indexPath : IndexPath) -> T? {
        return cellForItem(at: indexPath) as? T
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
//            self.delegateFeedTarget?.feedHitPoint(collectionView: self, at: IndexPath(row: 0, section: 0))
        }
    }
    func sharedInitilization()  {
        self.delegate = self
        self.dataSource = self
        
        if #available(iOS 10, *) {
            self.prefetchDataSource = self
        }
        viewLoadingAtBottom.backgroundColor = UIColor.clear
        viewLoadingAtBottom.addSubview(activityIndicator)
        self.addSubview(viewLoadingAtBottom)
        if #available(iOS 10, *) {
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
    func shallFetchMore(){
        if enableFetching && !isBeingFetched && scrollFeedDirection == .down && autoFetchingWhenScroll && !shallStopFetchingMore {
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
    
    var isBottomTopScreen : Bool {
        get {
            return (self.contentOffset.y + self.bounds.height + self.bottomInset  >= self.contentSize.height)  || (self.contentOffset.y <= 0)
        }
    }
    
    func hitAtPortionOfTheScreenHeight() {
        let scrollSpeed = abs(self.contentOffset.y - previousScrollViewOffset)
        previousScrollViewOffset = self.contentOffset.y
        if  scrollSpeed <= 25 && !isBottomTopScreen {
            DispatchQueue.global(qos: .userInteractive).async {
                if let hitIndexPath = self.indexPathForItem(at: self.portionHitPosition) {
                    self.currentHitIndexPath = hitIndexPath
                    DispatchQueue.main.async {
                        self.delegateFeedTarget?.feedHitPoint(collectionView: self, at: hitIndexPath)
                    }
                }
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollFeedDirection = .none
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lastestOffset = scrollView.contentOffset
        if scrollView.contentOffset.y - lastestOffset.y >= 0 {
            scrollFeedDirection = .down
        }else {
            scrollFeedDirection = .up
        }
        shallFetchMore()
        if delegateFeedTarget != nil {
            hitAtPortionOfTheScreenHeight()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.contentOffset.y + self.bounds.height >=  self.contentSize.height{
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

