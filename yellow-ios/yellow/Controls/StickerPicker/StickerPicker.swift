//
//  StickerCollection.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/12/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit

@objc protocol StickerPickerDelegate {
    @objc optional func stickerPicker(selected model : StickerModel ,pageDataSet : Int)
}

@IBDesignable
class StickerPicker: UIControl {
    lazy var  queue  : OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 5
        q.qualityOfService = .userInitiated
        return q
    }()
    fileprivate var isAnimatingScrollViewOffset : Bool = false
    var delegate : StickerPickerDelegate?
    var dataSet : [[StickerModel]]!
    var pickerDataSet : [StickerSetPickerModel]!
    fileprivate var isAlreadyInitilization = false
    
    fileprivate lazy var collections : [StickerCollection] = []
    fileprivate  var pickerSet : StickerSetPicker!
    let ratioTopHeight :  CGFloat = 2 / 3
    lazy var topContainerWihScroll : UIScrollView = {
        let s = UIScrollView()
        s.delegate = self
        s.showsVerticalScrollIndicator = false
        s.showsHorizontalScrollIndicator = false
        return s
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitilization()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitilization()
    }
    func sharedInitilization()  {
        topContainerWihScroll.isPagingEnabled = true
        let layout = UICollectionViewFlowLayout()
        pickerSet = StickerSetPicker(frame: CGRect.zero , collectionViewLayout: layout)
        pickerSet.backgroundColor = UIColor.white
        pickerSet.stickerSetPickerDatasource = self
        pickerSet.stickerSetPickerDelegate = self
        self.addSubview(topContainerWihScroll)
        self.addSubview(pickerSet)
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if pickerSet.frame  == CGRect.zero {
            let targetRect = rectOfBottomContainer
            pickerSet.frame = targetRect
            topContainerWihScroll.frame = CGRect(x: 0, y: 0
                , width: self.bounds.width, height: self.bounds.height * ratioTopHeight)
        }
    }
    var rectOfBottomContainer : CGRect  {
        get{
            return CGRect(x: 0, y: self.bounds.height * ratioTopHeight , width: self.bounds.width
                , height: self.bounds.height * ( 1 - ratioTopHeight))
        }
    }
    func performInitilization ( startIndex : Int? ) {
        if dataSet == nil
            || dataSet.count == 0
            || pickerDataSet == nil
            || pickerDataSet.count == 0
            || pickerDataSet.count != dataSet.count        {
            fatalError("no stickerSetData")
        }
        if isAlreadyInitilization == true {
            return
        }
        isAlreadyInitilization = true
        let boundSizeOfTopContainer = topContainerWihScroll.bounds
        topContainerWihScroll.contentSize = CGSize(width: boundSizeOfTopContainer.width * CGFloat(dataSet.count)
            , height: boundSizeOfTopContainer.height)
        for (index,_) in dataSet.enumerated() {
            let targetRect = CGRect(x:CGFloat(index) *  boundSizeOfTopContainer.width , y: 0, width: boundSizeOfTopContainer.width, height: boundSizeOfTopContainer.height)
            let layout = UICollectionViewFlowLayout()
            let collection = StickerCollection(frame: targetRect, collectionViewLayout: layout)
            collection.models = dataSet[index]
            collection.stickerDataSource = self
            collection.stickerDelegate = self
            collections.append(collection)
            topContainerWihScroll.addSubview(collection)
            collection.reloadDataAdvance()
        }
        pickerSet.models = pickerDataSet
        pickerSet.reloadDataAdvance()
        let startIndexPath = IndexPath(item: startIndex ?? 0 , section: 0)
        setTargetDisplayOffset(at: startIndexPath, animated: false)
    }
    fileprivate func setTargetDisplayOffset(at indexPath : IndexPath , animated : Bool = false){
        let x = rectOfBottomContainer.width * CGFloat(indexPath.item)
        let targetPoint = CGPoint(x: x, y: 0)
        isAnimatingScrollViewOffset = animated
        topContainerWihScroll.setContentOffset(targetPoint, animated: animated)
        pickerSet.selectItem(at: indexPath, animated: animated, scrollPosition: UICollectionViewScrollPosition.left)
    }
    func setPage(index : Int)  {
        if index < 0 || index > dataSet.count - 1 {
            return
        }
        setTargetDisplayOffset(at: IndexPath(item: index, section: 0) , animated: false)
    }
}
extension StickerPicker : StickerSetPickerDatasource {
    func didFinishLoadData(_ collectionView: StickerSetPicker) {
        
    }
}
extension StickerPicker : StickerSetPickerDelegate {
    func stickerSetPicker(_ collectionView: StickerSetPicker, didSelectItemAt indexPath: IndexPath) {
        setTargetDisplayOffset(at: indexPath, animated: true)
    }
}
extension StickerPicker: StickerCollectionDatasource  {
    func didFinishReloadData(_ collectionView: StickerCollection) {
        
    }
}
extension StickerPicker : StickerCollectionDelegate {
    func stickerCollection(_ collectionView: StickerCollection, didSelectItemAt indexPath: IndexPath, didSelectStickerModelAt model: StickerModel) {
        let model = model.clone()
        let pageDataSet = Int(round(self.topContainerWihScroll.contentOffset.x / self.topContainerWihScroll.bounds.width))
        delegate?.stickerPicker?(selected: model, pageDataSet: pageDataSet)
    }
}
extension StickerPicker : UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == topContainerWihScroll {
            isAnimatingScrollViewOffset = false
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == topContainerWihScroll && !isAnimatingScrollViewOffset {
            let index = Int( max( 0 , round((scrollView.contentOffset.x / self.bounds.width))))
            let indexPath = IndexPath(item: index, section: 0)
            pickerSet.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.left)
        }
    }
}






