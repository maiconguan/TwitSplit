//
//  ActivityProgressView.swift
//  TwitSplitApp
//
//  Created by khoa on 9/1/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import UIKit

class ActivityProgressView : UIView {
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var progressBarView: UIProgressView!
    @IBOutlet weak var indicatorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dialogView.layer.borderWidth = 5
        dialogView.layer.borderColor = UIColor.white.cgColor
        
        privateInit()
    }
    
    private func privateInit() {
        activityIndicatorView.startAnimating()
        
        progressBarView.isHidden = true
        indicatorLabel.isHidden = true
    }
    
    func updateProgress(spending: Int, total: Int) {
        
        progressBarView.isHidden = false
        indicatorLabel.isHidden = false
        
        progressBarView.progress = Float(spending) / Float(total)
        indicatorLabel.text = String(spending) + " / " + String(total)
    }
}
