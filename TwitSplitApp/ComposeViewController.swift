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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var controlView: UIView!
    
    var composingDelegate:ComposeViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Compose"
    }
    @IBAction func tweetButtonPressed(_ sender: Any) {
        if((composingDelegate) != nil) {
            composingDelegate?.composingCompleted(message: textView.text)
        }
        
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) { 
            
        }
    }

    // textview delegate
    func textViewDidChange(_ textView: UITextView) {
        let textLength = Int(textView.text.characters.count)
        
        tweetButton.isEnabled = (textLength > 0)
        
        numberLabel.text = String(textView.text.characters.count)
    }
}
