//
//  StickerSetChooser.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/13/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit

@objc protocol StickerSetPickerDatasource {
    @objc optional func didFinishLoadData(_ collectionView : StickerSetPicker )
}
@objc protocol  StickerSetPickerDelegate {
    @objc optional func stickerSetPicker(_ collectionView: StickerSetPicker, didSelectItemAt indexPath: IndexPath)
}
class StickerSetPicker: UICollectionView {
    let celIdentifier = "StickerSetPickerCell"
    var models : [StickerSetPickerModel]!
    var stickerSetPickerDatasource : StickerSetPickerDatasource?
    var stickerSetPickerDelegate : StickerSetPickerDelegate?
    fileprivate let insetHorizontal : CGFloat = 10
    fileprivate let insetVertical : CGFloat = 5
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
        self.allowsMultipleSelection = false
        self.register(nib, forCellWithReuseIdentifier: celIdentifier)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clear
        self.contentInset = UIEdgeInsetsMake(insetVertical, insetHorizontal, insetVertical, insetHorizontal)
    }
    func reloadDataAdvance() {
        self.reloadData()
        self.performBatchUpdates({
        }) { (isDone) in
            self.stickerSetPickerDatasource?.didFinishLoadData?(self)
        }
    }
    override func selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionViewScrollPosition) {
        super.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        
    }
}
extension StickerSetPicker : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        stickerSetPickerDelegate?.stickerSetPicker?(self, didSelectItemAt: indexPath)
//        print(#function)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        print(#function)
    }
}
extension StickerSetPicker : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.bounds.width - insetHorizontal * 2) / 5
            , height: (self.bounds.height - insetVertical * 2))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
   
}
extension StickerSetPicker : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return models.count == 0 ? 0 : 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: celIdentifier, for: indexPath) as! StickerSetPickerCell
            cell.hightlightColor = models[indexPath.item].highLightColor
            cell.imv_icon.image = models[indexPath.item].iconImage
            return cell
    }
}
