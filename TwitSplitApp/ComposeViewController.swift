//
//  ComposeViewController.swift
//  TwitSplitApp
//
//  Created by khoa on 8/30/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import UIKit
import TwitterKit


protocol ComposeViewControllerDelegate {

    func composingCompleted(message: String)
    
}


class ComposeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textView: PlaceholderTextView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var controlView: UIView!
    
     var composingDelegate:ComposeViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Compose"
        
        self.textView.placeholder = NSLocalizedString("What's happening?", comment: "")
        
        prepareForAppearance()
        
        NotificationCenter.default.addObserver( self,
                                                selector: #selector(prepareForAppearance),
                                                name: .UIApplicationWillEnterForeground,
                                                object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        
    }
    
    func prepareForAppearance() {
        self.textView.becomeFirstResponder()
        textViewDidChange(self.textView)
    }
    
    func dismiss() {
        self.textView.resignFirstResponder()
        
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func tweetButtonPressed(_ sender: Any) {
        if((composingDelegate) != nil) {
            composingDelegate?.composingCompleted(message: (textView.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
        }
        
        dismiss()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss()
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            let contraint = self.view.constraints.filter { $0.identifier == "controlViewContraintBottom" }.first
            
            contraint?.constant = keyboardRectangle.height
            
            self.view.layoutSubviews()
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let contraint = self.view.constraints.filter { $0.identifier == Contants.StoryboardKeys.composingControlViewContraintBottom }.first
        
        contraint?.constant = 0
        
        self.view.layoutSubviews()
    }
    
    // textview delegate
    func textViewDidChange(_ textView: UITextView) {
        
        let trimmedString = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        tweetButton.isEnabled = (trimmedString.length() > 0)
        
        numberLabel.text = String(textView.text.length())
    }
}
