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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = NSLocalizedString("TwitSplit", comment: "")
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
            }
        })
    }
    
    func postTweet(message: String) {
        
        let chunks = String.splitMessage(message: message)
        
        if chunks == nil {
            // display error 
            
            return
            
        }

        // print out for debug
        for chunk in chunks! {
            print(chunk + "    ==> \(chunk.length())" )
        }
        
        let client = TWTRAPIClient(userID: self.currentSession?.userID)
        
        DispatchQueue.global().async {
            self.postSerialTweets(messages: chunks!, currentMsg: 0, client: client, completion: { (error) in
                if(error == nil) {
                    print("Successfully post ALL TWEETS")
                }
                else {
                    // display error 
                    print("Error : \(error?.localizedDescription)")
                    print("STOP posting TWEETS")
                }
            })
        }
        
    }
    
    func postSerialTweets(messages:[String], currentMsg:Int, client: TWTRAPIClient, completion: @escaping ((Error?) -> Void)) {
        
        if currentMsg >= messages.count {
            completion(nil)
            
            return
        }
        
        client.sendTweet(withText: messages[currentMsg]) { (tweet, error) in
            if ((tweet) != nil) {
                print("Successfully composed Tweet")
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                    self.postSerialTweets(messages: messages, currentMsg: currentMsg + 1, client: client, completion: completion)
                }
                
                
            } else {
                completion(error)
            }
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

