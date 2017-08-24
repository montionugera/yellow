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

class VideoViewController: UIViewController {
    
    @IBOutlet var vdoContainerView: UIView!
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var videoURL: URL
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    var postprofileController : PostProfileViewController?
    var requireLoadNewUI = false
    @IBOutlet var postDetailContainerView: UIView!
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(requireLoadNewUI){
            self.postprofileController = PostProfileViewController(nibName: "PostProfileViewController", bundle: nil)
            self.postDetailContainerView.addSubview((self.postprofileController?.view)!)
            self.view.backgroundColor = UIColor.gray
            player = AVPlayer(url: videoURL)
            playerController = AVPlayerViewController()
            
            guard player != nil && playerController != nil else {
                return
            }
            playerController!.showsPlaybackControls = false
            
            playerController!.player = player!
            self.addChildViewController(playerController!)
            self.vdoContainerView.addSubview(playerController!.view)
            playerController!.view.frame = view.frame
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
            
            let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
            cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
            cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
            view.addSubview(cancelButton)
        }
        player?.play()
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func post(_ sender: Any) {
        //Post
        
        let user = Auth.auth().currentUser!
        let fileExt = self.videoURL.pathExtension
        
        //// Upload Media
        // Create a root reference// Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        // Create a reference to "uid"
        let uid = UUID().uuidString
        let mediaRef = storageRef.child("media/"+user.uid+"/"+uid+"."+fileExt)
        // Upload the file to the path "images/dummy.mov"
        let uploadTask = mediaRef.putFile(from:self.videoURL, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let mediaURL = metadata.downloadURL()
            let postDesc = "ข้างหน้าเป็นยังไงบ้างครับ ติดมากไหม"
            let mediaType = fileExt
            let addedByUser = fileExt
            
        }
        
        
        // move to rootView
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
}
