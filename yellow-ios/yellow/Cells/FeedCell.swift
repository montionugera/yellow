//
//  FeedCell.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/6/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//
import UIKit
import Firebase
class FeedCell: UICollectionViewCell {
    static func getRecommendHeight() -> CGFloat {
        switch UIScreen.main.bounds.height {
        case 568.0:
            return 420
        case 667:
            return 470
        case 736:
            return 510
        default:
            return 470
        }
    }
    lazy var lb_indexPath : UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.red
        return lb
    }()
    @IBOutlet weak var playerManager: AVPlayerManager!
    @IBOutlet weak var lb_userName: UILabel!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_location: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var img_userProfile: ImageRoundCorner!
    @IBOutlet weak var img_emo: ImageRoundCorner!
    @IBOutlet weak var img_love: UIImageView!
    @IBOutlet weak var lb_loveCount: UILabel!
    var firebaseAPI : FirebaseAPI!
    var feedContent : FeedContent!
    weak var operation : Operation?
    override func awakeFromNib() {
        super.awakeFromNib()
        sharedInitilization()
    }
    func sharedInitilization() {
        self.layer.cornerRadius = 10
        playerManager.config = AVPlayerConfigulation(isPlayOnReady: false, isInfinite: true)
        self.addSubview(lb_indexPath)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.ClickLove(_:)))
        self.img_love.isUserInteractionEnabled = true
        self.img_love.addGestureRecognizer(tapGesture)
        firebaseAPI = FirebaseAPI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        playerManager.releaseObserver()
        operation?.cancel()
        operation = nil
        }
    @IBAction func ClickLove(_ sender: UITapGestureRecognizer) {
        if let fc = feedContent {
            self.lb_loveCount.text = "\(Int(self.lb_loveCount.text!)! + 1)"
            self.firebaseAPI.update(feedContent: fc)
            Analytics.logEvent("like",
                parameters: [
                "name": UserModel.currentUser.user_name ?? ""
                ,"post_id" : fc.key])
        }
    }
}
