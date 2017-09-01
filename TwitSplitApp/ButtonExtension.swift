//
//  ButtonExtension.swift
//  TwitSplitApp
//
//  Created by khoa on 9/1/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonExtension: UIButton {
    
    @IBInspectable var highlightedBackgroundColor: UIColor = UIColor.lightGray
    @IBInspectable var defaultBackgroundColor: UIColor = UIColor.blue
    @IBInspectable var disableBackgroundColor: UIColor = UIColor.gray
    
    
    override var isHighlighted :Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedBackgroundColor : defaultBackgroundColor
        }
        
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? defaultBackgroundColor : disableBackgroundColor
        }
    }
    
    @IBInspectable var roundCorner: Bool = false {
        didSet {
            if roundCorner {
                layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2
            }
            else {
                layer.cornerRadius = 0.0
            }
        }
    }
}
