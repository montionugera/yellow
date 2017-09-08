//
//  FeedCell.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/6/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    lazy var lb_indexPath : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.red
        return lb
    }()
    
    @IBOutlet weak var playerManager: AVPlayerManager!
    @IBOutlet weak var lb_userName: UILabel!
    @IBOutlet weak var lb_title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        sharedInitilization()
    }
    func sharedInitilization() {
        self.layer.cornerRadius = 10
        playerManager.config.isReadyOnPlay = false
        self.addSubview(lb_indexPath)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        playerManager.releaseObserver()
    }
}
