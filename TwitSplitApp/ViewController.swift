//
//  ViewController.swift
//  TwitSplitApp
//
//  Created by khoa on 8/30/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: TWTRTimelineViewController {

    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "TwitSplit"
        self.tableView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginTwitter() {
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName)");
                
                DispatchQueue.main.async(execute: {
                    self.title = (session?.userName)
                    
                    self.dataSource = TWTRUserTimelineDataSource(screenName: (session?.userName)!, apiClient: TWTRAPIClient())
                    
                    self.refresh()
                    
                    self.tableView.isHidden = false
                })
                
                
                
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginTwitter()
    }

}

