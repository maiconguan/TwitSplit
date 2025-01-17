//
//  WelcomeView.swift
//  TwitSplitApp
//
//  Created by khoa on 9/1/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import UIKit
import TwitterKit

protocol WelcomeViewDelegate {
    func performLoginTwitter()
}

class WelcomeView : UIView {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var loginButton: ButtonExtension!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var welcomeDelegate: WelcomeViewDelegate? = nil
    

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        privateInit()
    }
    
    private func privateInit() {
        activityView.startAnimating()
    }
    
    func isActivityHidden(_ value: Bool) {
        activityView.isHidden = value
        loginButton.isHidden = !value
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if(self.welcomeDelegate != nil) {
            self.welcomeDelegate?.performLoginTwitter()
        }
    }
    
    func faceIn(duration: TimeInterval = 1.0, completion:(()->Void)?) {
        loginButton.isEnabled = false
        
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: [.curveLinear],
                       animations: { () -> Void in
                            self.logoImage.transform = CGAffineTransform(scaleX: 20.0, y: 20.0)
                        }){ (animationCompleted: Bool) -> Void in
                            
                            completion!()
                        }
    }
    
    func faceOut(duration: TimeInterval = 1.0) {
        logoImage.transform = CGAffineTransform(scaleX: 20.0, y: 20.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.logoImage.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
            self.boundingEffect()
        }
    }
    
    func boundingEffect(duration: TimeInterval = 1.0) {
        
        logoImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        self.logoImage.transform = CGAffineTransform.identity
        }, completion: { _ in
            
        })
    }
    
}
