//
//  FeedViewController.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/6/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//
import UIKit
class SecondViewController: UIViewController {
    lazy var viewModel : SecondViewModel = {
        let vm = SecondViewModel(instance: self)
        return vm
    }()
    @IBOutlet weak var feed: FeedCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        feed.registerAdvance(FeedCell.self, nib: UINib(nibName: "FeedCell", bundle: nil))
        feed.delegateFeed = self
        feed.delegateFeedLayout = self
//        feed.delegateFeedTarget = self
        viewModel.initilization()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SecondViewController : SecondViewModelDelegate {
    func didFinishLoadData(hasData: Bool) {
        if hasData {
            feed.reloadDataAdvance()
        }
    }
}
extension SecondViewController : FeedCollectionViewDelegate {
    func feedNumberOfSections (in collectionView: UICollectionView ) -> Int {
        return viewModel.numberOfRecords == 0 ? 0 : 1
    }
    func feedNumberOfItemsInSection(_ collectionview : UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRecords
    }
    func feedCellForItem(collectionview: FeedCollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FeedCell = collectionview.dequeueReusableCellAdvance(forIndexPath: indexPath)
        viewModel.bindCell(cell: cell, at: indexPath)
        return cell
    }
    func feedFetchMoreDataOnScrollDown(){
        self.feed.doneFetching(isAnimiated: true, shallStopFetching: true, completion: nil)
    }
    func feedFetchMoreDataOnPulling(){
        
    }
    func feedRefresh(){
        self.feed.finishRefresh()
    }
    func feed(didSelectItemat indexPath: IndexPath) {
        
    }
}
extension SecondViewController : FeedCollectionViewDelegateFlowLayout {
    func feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, contentRemainingSize: CGSize, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width , height: contentRemainingSize.height / 1.2)
    }
    func  feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func feedCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 15
    }
}
