//
//  PostProfileViewController.swift
//  yellow
//
//  Created by montionugera on 8/22/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import FirebaseStorage
import FBSDKLoginKit
import Firebase
import IHKeyboardAvoiding

class PostProfileViewController: BaseViewController {
    
    @IBOutlet weak var inputContainer: UIView!
    @IBOutlet var vdoContainerView: UIView!
    
    @IBOutlet weak var des_tx: UITextField!
    @IBOutlet weak var emo_bt: UIButton!
    
    @IBOutlet weak var admin_lat_tx: UITextField!
    @IBOutlet weak var admin_long_tx: UITextField!
    @IBOutlet weak var admin_view: UIView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var emoChar: String
    private var emoImg: UIImage
    private var videoURL: URL
    
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    var requireLoadNewUI = false
    
    init(videoURL: URL , emoChar: String , emoImg: UIImage) {
        self.videoURL = videoURL
        self.emoChar = emoChar
        self.emoImg = emoImg
        super.init(nibName: "PostProfileViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requireLoadNewUI = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.des_tx.frame.size.height))
        self.des_tx.leftView = paddingView
        self.des_tx.leftViewMode = .always
        
        self.emo_bt.setImage(self.emoImg, for: .normal)
        let emoString = self.emoChar
        let emoArray = emoString.components(separatedBy: ",")
        if(emoArray.count == 2){
            let colorID = emoArray[0]
            self.emo_bt.tintColor = MappingPinEmo.shareInstace.mappingBGColor(colorID: colorID)
        }
        
        let em = UserModel.currentUser.user_email
        if(em == "ek_dan@hotmail.com" || em == "fio_fiore10234@hotmail.com" || em == "yellowerth@gmail.com" || em == "orapat.ch@gmail.com" || em == "montionugera@gmail.com" || em == "v.laotrakul.fb@gmail.com" || em == "yellowerth@gmail.com"){
            self.admin_view.isHidden = false
        }
        
        self.inputContainer.layer.masksToBounds = false
        self.inputContainer.layer.shadowColor = UIColor.black.cgColor
        self.inputContainer.layer.shadowOpacity = 0.5
        self.inputContainer.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.inputContainer.layer.shadowRadius = 1
        
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
            
            KeyboardAvoiding.avoidingView = self.inputContainer
            
        }
        player?.play()
    }
    
    
    @IBAction func backNav() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel() {
        player?.pause()
        //        dismiss(animated: true, completion: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func post(_ sender: Any) {
        player?.pause()
        
        self.showLoding()
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
        let _ = mediaRef.putFile(from:self.videoURL, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let postDesc = self.des_tx.text
            let addedByUser = String(describing: UserModel.currentUser.user_id)
            let addedByUserName = UserModel.currentUser.user_name
            let addedByUserURL = UserModel.currentUser.user_profile
            let mediaType = fileExt
            let mediaURL = metadata.downloadURL()!.absoluteString
            let love = 0
            if let cc = currentLocationYellow {
                let lochash = Geohash.encode(latitude: (((self.admin_lat_tx.text?.characters.count)! > 0) ? Double(self.admin_lat_tx.text!) : cc.coordinate.latitude)!,
                                             longitude: (((self.admin_long_tx.text?.characters.count)! > 0) ? Double(self.admin_long_tx.text!)! : cc.coordinate.longitude), length: 12)
                let postData = ["postDesc":postDesc ?? "",
                                "addedByUser":addedByUser ,
                                "addedByUserName":addedByUserName ?? "",
                                "addedByUserURL":addedByUserURL ?? "",
                                "mediaType":mediaType,
                                "mediaURL":mediaURL,
                                "love":love,
                                "emo": (self.emoChar.characters.count > 0)  ? self.emoChar : "1,1",
                                "place": currentPlaceYellow ?? "",
                                "postDttmInt": Date().timeIntervalSince1970,
                                "postDttmStr": getStandardAppDateString(dttm: Date()),
                                "lochash":lochash] as [String : Any]
                
                let postRef = ref.child("posts")
                let newPostRef = postRef.childByAutoId()
                newPostRef.setValue(postData) { (error, ref) -> Void in
                    self.hideLoding()
                    if error != nil {
                        self.showAlertDefault(msg: String(describing: error))
                    } else {
                        Analytics.logEvent("post", parameters: [
                            "userName":  UserModel.currentUser.user_name ?? "" ])
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
}

extension PostProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField){
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
