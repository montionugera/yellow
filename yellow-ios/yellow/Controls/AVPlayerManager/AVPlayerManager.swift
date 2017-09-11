//
//  AVPlayerManager.swift
//  YellowModule
//
//  Created by Nattapong Unaregul on 9/5/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
struct AVPlayerConfigulation {
    var isReadyOnPlay : Bool = true
}
@IBDesignable
class AVPlayerManager: UIControl {
    fileprivate var _config : AVPlayerConfigulation? = nil
    var config : AVPlayerConfigulation {
        get {
            if _config == nil {
                _config = AVPlayerConfigulation(isReadyOnPlay: true)
            }
            return _config!
        }set{
            _config = newValue
        }
    }
    let avPlayer  =  AVPlayer(playerItem: nil)
    var playerItemContext : UnsafeMutableRawPointer?
    let avLayer : AVPlayerLayer = AVPlayerLayer()
    var playerItem : AVPlayerItem?
    var amountOfTimeToPlay : Int?
    
    var operationPrepareVideo : Operation?
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitilization()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.backgroundColor = UIColor.black
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitilization()
    }
    func sharedInitilization()  {
        avLayer.frame = self.bounds
        avLayer.player  = avPlayer
        avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.layer.addSublayer(avLayer)
    }
    func prepare(urlPath : String)  {
        
        guard  let url = URL(string: urlPath) else {
            return
        }
        DispatchQueue.global(qos: .userInteractive).async {
            let asset = AVAsset(url: url)
            let assetKeys = [
                "playable"
            ]
            self.playerItem = AVPlayerItem(asset: asset,
                                           automaticallyLoadedAssetKeys: assetKeys)
//            self.playerItem?.addObserver(self,
//                                         forKeyPath: #keyPath(AVPlayerItem.status),
//                                         options: [.old, .new],
//                                         context: &self.playerItemContext)
            self.avPlayer.replaceCurrentItem(with: self.playerItem)
        }
    }
    func play(amountOfTime : Int? = nil)  {
        avPlayer.play()
        if let amountOfTime = amountOfTime {
            let specificTime = CMTime(seconds: Double(amountOfTime), preferredTimescale: CMTimeScale(bigEndian: 64))
            let timeValue = NSValue(time: specificTime)
            self.avPlayer.addBoundaryTimeObserver(forTimes: [timeValue], queue: DispatchQueue.global(qos: .userInteractive))
            {[weak self] time in
                self?.avPlayer.pause()
            }
        }
    }
    func pause(){
        avPlayer.pause()
    }
    deinit {
        releaseObserver()
    }
    func releaseObserver() {
        avPlayer.pause()
        avPlayer.replaceCurrentItem(with: nil)
//        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
       
    }
//    override func observeValue(forKeyPath keyPath: String?,
//                               of object: Any?,
//                               change: [NSKeyValueChangeKey : Any]?,
//                               context: UnsafeMutableRawPointer?) {
//        guard context == &playerItemContext else {
//            super.observeValue(forKeyPath: keyPath,
//                               of: object,
//                               change: change,
//                               context: context)
//            return
//        }
//        if keyPath == #keyPath(AVPlayerItem.status) {
//            let status: AVPlayerItemStatus
//            if let statusNumber = change?[.newKey] as? NSNumber {
//                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
//            } else {
//                status = .unknown
//            }
//            switch status {
//            case .readyToPlay:
//                if config.isReadyOnPlay {
//                    play(amountOfTime: self.amountOfTimeToPlay)
//                }
//                break;
//            case .failed:
//                break;
//            case .unknown:
//                break;
//            }
//        }
//    }
}
