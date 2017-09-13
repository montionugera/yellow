//
//  StickerCollection.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/12/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit
@objc protocol StickerPickerDelegate {
    @objc optional func stickerPicker(model : StickerModel)
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
        self.backgroundColor = UIColor.black
        topContainerWihScroll.isPagingEnabled = true
        self.addSubview(topContainerWihScroll)
        topContainerWihScroll.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height * ratioTopHeight)
        topContainerWihScroll.backgroundColor = UIColor.lightGray
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    func performInitilization ( startIndex : Int? ) {
        //(pickerDataSet.count != dataSet.count )
        if dataSet == nil
            || dataSet.count == 0
            || pickerDataSet == nil
            || pickerDataSet.count == 0
            || pickerDataSet.count != dataSet.count {
            fatalError("unsatisfied condition StickerPicker sticker's dataset not equal to picker's dataset")
        }
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
        let targetRect = CGRect(x: 0, y: self.bounds.height * ratioTopHeight , width: self.bounds.width
            , height: self.bounds.height * ( 1 - ratioTopHeight))
        let layout = UICollectionViewFlowLayout()
        pickerSet = StickerSetPicker(frame: targetRect, collectionViewLayout: layout)
        pickerSet.models = pickerDataSet
        pickerSet.stickerSetPickerDatasource = self
        pickerSet.stickerSetPickerDelegate = self
        pickerSet.backgroundColor = UIColor.brown
        self.addSubview(pickerSet)
        pickerSet.reloadDataAdvance()
        
        let startIndexPath = IndexPath(item: startIndex ?? 0 , section: 0)
        setTargetDisplayOffset(at: startIndexPath, animated: true)
    }
    func setTargetDisplayOffset(at indexPath : IndexPath , animated : Bool = false){
        let x = topContainerWihScroll.bounds.width * CGFloat(indexPath.item)
        let targetPoint = CGPoint(x: x, y: 0)
        isAnimatingScrollViewOffset = true
        topContainerWihScroll.setContentOffset(targetPoint, animated: true)
        
        pickerSet.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.left)
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
        delegate?.stickerPicker?(model: model)
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






