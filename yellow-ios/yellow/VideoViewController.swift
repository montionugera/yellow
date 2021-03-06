/*Copyright (c) 2016, Andrew Walz.
 
 Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

import UIKit
import AVFoundation
import AVKit
import FirebaseStorage

import FBSDKLoginKit
import Firebase
extension VideoViewController :StickerPickerDelegate {

    func stickerPicker(selected model: StickerModel, pageDataSet: Int) {

        let emoImage =  MappingPinEmo.shareInstace.mappingEmo(colorID: String(model.containerSetId), emoID: String(model.id))
    
        self.nextVCT(String(model.containerSetId) + "," + String(model.id) , emoImage: emoImage)
    }
}
class VideoViewController: UIViewController {
    var currentPageIndex : Int = 0
    @IBOutlet weak var stickerPicker: StickerPicker!
    @IBOutlet var vdoContainerView: UIView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    private var videoURL: URL
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    var requireLoadNewUI = false
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: "VideoViewController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        requireLoadNewUI = true
        stickerPicker.delegate = self
        stickerPicker.dataSet = StickerDataSetGenerator.getDataSet()
        stickerPicker.pickerDataSet = StickerDataSetGenerator.getPickerIcons()
        print("viewDidLoad:\(self.view.bounds)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews:\(self.view.bounds)")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(requireLoadNewUI){
            player = AVPlayer(url: videoURL)
            playerController = AVPlayerViewController()
            guard player != nil && playerController != nil else {
                return
            }
            playerController!.showsPlaybackControls = false
            playerController!.player = player!
            self.addChildViewController(playerController!)
            self.vdoContainerView.addSubview(playerController!.view)
            //            playerController!.view.frame = CGRect(x: 0, y: 0, width: vdoContainerView.bounds.size.width, height: vdoContainerView.bounds.size.height)
            
            playerController!.view.frame = CGRect(x: 0, y: (vdoContainerView.bounds.size.height/2 - view.bounds.size.height/2), width: view.bounds.size.width, height: view.bounds.size.height)
            
            //            playerController!.view.frame = view.frame
            //playerController!.view.alpha = 0.3
            //            playerController?.view.center = self.vdoContainerView.center
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        }
        player?.play()
    }
    @IBAction func cancel() {
        player?.pause()
        dismiss(animated: true, completion: nil)
        //self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func nextVCT(_ sender: Any , emoImage : UIImage) {
        player?.pause()
        let postprofileController : PostProfileViewController = PostProfileViewController(videoURL: self.videoURL , emoChar: sender as! String , emoImg: emoImage)
        self.navigationController?.pushViewController(postprofileController, animated: true)
    }
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
}
