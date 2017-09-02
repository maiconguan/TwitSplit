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

class MenuViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var menuView: UIView!
    
    var menuDelegate:MenuViewControllerDelegate? = nil
    
    @IBAction func closeMenuButtonPressed(_ sender: Any) {
        self.closeSideMenu()
    }
    
    func closeSideMenu() {
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
    
    func displayAvatarImage(path: String) {
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.layer.borderWidth = 5
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        
        self.avatarImageView.sd_setImage(with: URL(string:path), completed: nil)
    }
    
}
