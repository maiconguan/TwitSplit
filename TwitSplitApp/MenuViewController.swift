//
//  MenuViewController.swift
//  TwitSplitApp
//
//  Created by khoa on 9/1/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import UIKit
import SDWebImage

protocol MenuViewControllerDelegate {
    func sideMenuDidClose()
}

class MenuViewController: UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var statusesCountLabel: UILabel!
    @IBOutlet weak var omitEmptySwitch: UISwitch!
    @IBOutlet weak var reverseSwitch: UISwitch!
    @IBOutlet weak var aboutWebView: UIWebView!
    @IBOutlet weak var friendsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var formatedNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var menuView: UIView!
    
    var menuDelegate:MenuViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // loading about
        let url = Bundle.main.url(forResource: "About", withExtension: "html")
        self.aboutWebView.loadRequest(URLRequest(url: url!))
        
        // loading setting
        let settingValue = Helper.loadSetting()
        self.reverseSwitch.isOn = settingValue.first!
        self.omitEmptySwitch.isOn = settingValue.last!
    }
    
    @IBAction func closeMenuButtonPressed(_ sender: Any) {
        self.closeSideMenu()
    }
    
    func closeSideMenu() {
        // save setting 
        Helper.saveSetting(reversePostingOrder: self.reverseSwitch.isOn, omittingEmptySequence: self.omitEmptySwitch.isOn)
        
        let menuFrame = self.menuView.frame
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.menuView.frame = CGRect(x: -menuFrame.size.width,
                                     y: 0,
                                     width: menuFrame.size.width,
                                     height: menuFrame.size.height)
            self.view.layoutIfNeeded()
            
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            
            if self.menuDelegate != nil {
                self.menuDelegate?.sideMenuDidClose()
            }
            
        })
    }
    
    func openSideMenu() {
        let menuFrame = self.menuView.frame
        
        self.menuView.frame = CGRect(x: -menuFrame.size.width,
                                   y: 0,
                                   width: menuFrame.size.width,
                                   height: menuFrame.size.height)
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.menuView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: menuFrame.size.width,
                                         height: menuFrame.size.height)
            self.view.layoutIfNeeded()
        }, completion:nil)
    }
    
    func bindingUserProfileData(data: TwitterUserProfile) {
        self.displayBannerImage(path: data.profileBannerUrl)
        self.displayAvatarImage(path: data.profileImageUrl)
        self.nameLabel.text = data.userName
        self.formatedNameLabel.text = String("@") + data.screenName
        self.followersCountLabel.text = String(data.followersCount)
        self.friendsCountLabel.text = String(data.friendsCount)
        self.statusesCountLabel.text = String(data.statusesCount)
    }
    
    private func displayAvatarImage(path: String) {
        //print("displayAvatarImage:" + path)
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.layer.borderWidth = 5
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        
        self.avatarImageView.sd_setImage(with: URL(string:path), completed: nil)
    }
    
    private func displayBannerImage(path: String) {
        //print("displayBannerImage:" + path)
        
        self.bannerImageView.sd_setImage(with: URL(string:path), completed: nil)
    }
    
    // handle webview delegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // prevent opening the links inside this webview.
        if navigationType == UIWebViewNavigationType.linkClicked {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(request.url!)
            }
            return false
        }
        return true
    }
    
    
}
