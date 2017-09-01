//
//  ViewController.swift
//  TwitSplitApp
//
//  Created by khoa on 8/30/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: TWTRTimelineViewController, ComposeViewControllerDelegate {

    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    @IBOutlet weak var composeButton: UIBarButtonItem!
    
    var currentSession:TWTRSession? = nil
    
    var progressView:ActivityProgressView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = Helper.localizedString(key: "TwitSplit")
        
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
                
                self.currentSession = session
                
                DispatchQueue.main.async(execute: {
                    self.title = (session?.userName)
                    
                    self.dataSource = TWTRUserTimelineDataSource(screenName: (session?.userName)!, apiClient: TWTRAPIClient())
                    
                    self.refresh()
                    
                    self.tableView.isHidden = false
                })
                
                
                
            } else {
                print("error: \(error?.localizedDescription)")
                
                self.showAlert(titleKey: "Error", messageKey: "Cannot login twitter because of error: " + (error?.localizedDescription)!)
                
            }
        })
    }
    
    func postTweet(message: String) {
        // before sending tweets, should display an activity.
        DispatchQueue.main.async {
            self.addActivityProgressView()
        }
        
        let chunks = String.splitMessage(message: message)
        
        if chunks == nil {
            // remove the activity here
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.removeActivityProgressView()
            }

            
            // display error
            self.showAlert(titleKey: "Error", messageKey: "Cannot chunk the message")
            
            return
            
        }

        // print out for debug
        for chunk in chunks! {
            print(chunk + "    ==> \(chunk.length())" )
        }
        
        // before sending tweets, should display an activity.
        DispatchQueue.main.async {
            self.progressView?.updateProgress(spending: 0, total: (chunks?.count)!)
        }
        
        let client = TWTRAPIClient(userID: self.currentSession?.userID)
        
        DispatchQueue.global().async {
            self.postSerialTweets(messages: chunks!, currentMsg: 0, client: client,progression: { (spending, total) in
                DispatchQueue.main.async {
                    if(self.progressView != nil) {
                        self.progressView?.updateProgress(spending: spending, total: total)
                    }
                }
            }, completion: { (error) in
                // remove the activity here
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.removeActivityProgressView()
                }
                
                if(error == nil) {
                    // refresh tweets table here
                    self.refresh()
                    
                    print("Successfully post ALL TWEETS")
                }
                else {
                    // display error
                    self.showAlert(titleKey: "Error", messageKey: "Cannot post your tweet because of error: " + (error?.localizedDescription)!)
                }
            })
        }
        
    }
    
    func postSerialTweets(messages:[String], currentMsg:Int, client: TWTRAPIClient, progression: @escaping ((Int, Int)->Void),  completion: @escaping ((Error?) -> Void)) {
        
        if currentMsg >= messages.count {
            progression(currentMsg, messages.count)
            
            completion(nil)
            
            return
        }
        
        client.sendTweet(withText: messages[currentMsg]) { (tweet, error) in
            if ((tweet) != nil) {
                print("Successfully composed Tweet")
                
                progression(currentMsg, messages.count)
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                    self.postSerialTweets(messages: messages, currentMsg: currentMsg + 1, client: client,progression: progression, completion: completion)
                }
                
                
            } else {
                completion(error)
            }
        }
    }
    
    func addActivityProgressView() {
        if(self.progressView != nil) {
            return
        }
        
        self.progressView = Bundle.main.loadNibNamed("ActivityProgressView", owner: self, options: nil)?[0] as! ActivityProgressView
        
        self.navigationController?.view.addSubview(self.progressView!)
    }
    
    func removeActivityProgressView() {
        if(self.progressView != nil) {
            self.progressView?.removeFromSuperview()
            self.progressView = nil
        }
    }
    
    //handle segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Contants.StoryboardKeys.segueToComposing {
            let vc = segue.destination as! ComposeViewController
            vc.composingDelegate = self
        }
    }
    
    // handle compose wiew controler delegate
    func composingCompleted(message: String) {
        print("composingCompleted: " + message)

        postTweet(message: message)
    }
    
    // handle ibaction here
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginTwitter()
    }

    @IBAction func composeButtonPressed(_ sender: Any) {
        print("composeButtonPressed");

    }
    
}

