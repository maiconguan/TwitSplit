//
//  UITextView+Placeholder.swift
//  TwitSplitApp
//
//  Created by khoa on 8/31/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//


import UIKit

class PlaceholderTextView: UITextView {
    
    let placeholderLabel: UILabel = UILabel()
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        privateInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        privateInit()
    }
    
    private func privateInit() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeholderTextViewDidChange),
                                               name: NSNotification.Name.UITextViewTextDidChange,
                                               object: nil)
        
        addPlaceholder()
    }
    
    /// Resize the placeholder when the UITextView bounds change
    override var bounds: CGRect {
        didSet {
            self.updateConstraintsForPlaceholderLabel()
        }
    }
    
    // placeholder text
    var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
            placeholderTextViewDidChange()
        }
    }
    
    override var text: String? {
        didSet{
            placeholderTextViewDidChange()
        }
    }
    
    // Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
        ))
        
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder() {
        
        placeholderLabel.font = font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(placeholderLabel)
        
        updateConstraintsForPlaceholderLabel()
    }
    
    
    @objc private func placeholderTextViewDidChange() {
        placeholderLabel.isHidden = (self.text?.characters.count)! > 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange,object: nil)
    }
    
}
