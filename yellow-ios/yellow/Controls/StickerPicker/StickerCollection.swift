//
//  StickerCollection.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/13/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//
import UIKit
@objc protocol StickerCollectionDatasource {
    
    @objc optional func didFinishReloadData(_ collectionView: StickerCollection)
}
@objc protocol StickerCollectionDelegate{
    @objc optional func stickerCollection(_ collectionView: StickerCollection, didSelectItemAt indexPath: IndexPath,didSelectStickerModelAt model : StickerModel)
}
class StickerCollection: UICollectionView {
    var models : [StickerModel]!
    let celIdentifier = "StickerCell"
    var stickerDataSource : StickerCollectionDatasource!
    var stickerDelegate : StickerCollectionDelegate?
    fileprivate let inset : CGFloat = 15
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        sharedInitilization()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitilization()
    }
    func sharedInitilization(){
        let nib = UINib(nibName: celIdentifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: celIdentifier)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clear
        
        self.contentInset.top = inset
        self.contentInset.left = inset
        self.contentInset.right = inset
        self.contentInset.bottom = inset
    }
    func reloadDataAdvance() {
        self.reloadData()
        self.performBatchUpdates({
        }) { (isDone) in
            self.stickerDataSource.didFinishReloadData?(self)
        }
    }
}
extension StickerCollection : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let responseModel = models[indexPath.item].clone()
        stickerDelegate?.stickerCollection?(self, didSelectItemAt: indexPath, didSelectStickerModelAt: responseModel)
    }
}
extension StickerCollection : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let targetSize = (self.bounds.width - inset * 2) / 6
        return CGSize(width: targetSize , height: targetSize)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension StickerCollection : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return models.count == 0 ? 0 : 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: celIdentifier, for: indexPath) as! StickerCell
            cell.imv_icon.image = models[indexPath.item].iconImage
            return cell
    }
}
