//
//  FeedListVC.swift
//  yellow
//
//  Created by ekachai limpisoot on 9/5/17.
//  Copyright © 2017 23. All rights reserved.
//

import UIKit

class FeedListVC: BaseViewController {

    @IBOutlet weak var test_lb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(FeedListVC.updateFeedList), name: NSNotification.Name(rawValue: "updateFeedList"), object: nil)
    }

    func updateFeedList(_ notification: NSNotification) {
        if let feedContents = notification.userInfo?["FeedContents"] as? [FeedContent] {
            // do something with your image
            
            self.test_lb.text = "\(feedContents.count)"
            
            if (feedContents.count == 1){
                self.test_lb.text = self.test_lb.text! + feedContents[0].postDesc
            }
        }
        
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateFeedList"), object: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FeedListVC: PulleyDrawerViewControllerDelegate {
    
    func collapsedDrawerHeight() -> CGFloat
    {
        return 128.0
    }
    
    func partialRevealDrawerHeight() -> CGFloat
    {
        return UIScreen.main.bounds.height - 100
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all // You can specify the drawer positions you support. This is the same as: [.open, .partiallyRevealed, .collapsed, .closed]
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController)
    {
        //        tableView.isScrollEnabled = drawer.drawerPosition == .open
        
        if drawer.drawerPosition != .open
        {
            //            searchBar.resignFirstResponder()
        }
    }
}
