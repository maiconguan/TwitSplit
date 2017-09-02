//
//  ViewController.swift
//  TwitSplitApp
//
//  Created by khoa on 8/30/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

class ViewController: TWTRTimelineViewController, ComposeViewControllerDelegate, WelcomeViewDelegate, MenuViewControllerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var composeButton: UIBarButtonItem!

    var currentUser:TwitterUserProfile = TwitterUserProfile()
    
    var progressView:ActivityProgressView? = nil
    var welcomeView:WelcomeView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = Helper.localizedString(key: "TwitSplit")
        
        self.tableView.isHidden = true
        
        self.addWelcomeView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginTwitter() {
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName)");
                
                self.currentUser.userID = (session?.userID)!
                
                DispatchQueue.global().async(execute: {
                    self.getUserProfile()
                })
                
            } else {
                print("error: \(error?.localizedDescription)")
                
                self.showAlert(titleKey: "Error", messageKey: "Cannot login twitter because of error: " + (error?.localizedDescription)!)
                
            }
        })
    }
    
//    func getUserProfile() {
//        let client = TWTRAPIClient(userID: self.currentSession?.userID)
//        client.loadUser(withID: (currentSession?.userID)!) { (user, error) in
//            self.currentUser = user
//            
//            ///
//            print(user?.profileImageURL)
//            print(user?.profileImageMiniURL)
//            print(user?.profileImageLargeURL)
//            print(user?.profileURL)
//            print(user?.screenName)
//            print(user?.formattedScreenName)
//            print(user?.name)
//            ///
//            self.removeWelcomeView()
//            
//            DispatchQueue.main.async(execute: {
//                
//                
//                self.title = (user?.name)
//                
//                self.dataSource = TWTRUserTimelineDataSource(screenName: (user?.screenName)!, apiClient: TWTRAPIClient())
//                self.refresh()
//                self.tableView.isHidden = false
//                
//               
//            })
//            
//            self.getProfileBannerImage()
//        }
//    }
    
    func getUserProfile() {
        let client = TWTRAPIClient(userID: self.currentUser.userID)
        
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/show.json"
        let params = ["user_id": self.currentUser.userID] //["screen_name": self.currentUser?.screenName]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                self.currentUser.updateJsonData(json: json)
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
            
            self.removeWelcomeView()
            
            DispatchQueue.main.async(execute: {
                
                
                self.title = self.currentUser.userName
                
                self.dataSource = TWTRUserTimelineDataSource(screenName: self.currentUser.screenName, apiClient: TWTRAPIClient())
                self.refresh()
                self.tableView.isHidden = false
                
               
            })
        }
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
        
        let client = TWTRAPIClient(userID: self.currentUser.userID)
        
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
        
        self.progressView?.frame.size = (self.navigationController?.view.frame.size)!
        
        self.navigationController?.view.addSubview(self.progressView!)
    }
    
    func removeActivityProgressView() {
        if(self.progressView != nil) {
            self.progressView?.removeFromSuperview()
            self.progressView = nil
        }
    }
    
    func addWelcomeView() {
        if(self.welcomeView != nil) {
            return
        }
        
        self.welcomeView = Bundle.main.loadNibNamed("WelcomeView", owner: self, options: nil)?[0] as! WelcomeView
        
        self.welcomeView?.frame.size = (self.navigationController?.view.frame.size)!
        
        self.welcomeView?.welcomeDelegate = self
        
        self.navigationController?.view.addSubview(self.welcomeView!)
        
        self.welcomeView?.faceOut(duration: 0.5)
    }
    
    func removeWelcomeView() {
        if(self.welcomeView != nil) {
            self.welcomeView?.isUserInteractionEnabled = false
            DispatchQueue.main.async(execute: {
                self.welcomeView?.faceIn(duration: 0.5, completion: {
                    self.welcomeView?.removeFromSuperview()
                    self.welcomeView = nil
                })
            })
            
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
    @IBAction func menuButtonPressed(_ sender: Any) {
        openMenuView()
    }

    @IBAction func composeButtonPressed(_ sender: Any) {
        print("composeButtonPressed");

    }
    
    func openMenuView() {
        
        let menuViewCtrl = self.storyboard!.instantiateViewController(withIdentifier: Contants.StoryboardKeys.menuViewController) as! MenuViewController
        
        menuViewCtrl.menuDelegate = self
        self.navigationController?.view.addSubview(menuViewCtrl.view)
        self.navigationController?.addChildViewController(menuViewCtrl)
       
        //load use's photo
        menuViewCtrl.bindingUserProfileData(data: self.currentUser)
        
        menuViewCtrl.openSideMenu()
    }
    
    //handle MenuViewControllerDelegate
    func sideMenuDidClose() {
        
    }
    
    // handle WelcomeViewDelegate
    func performLoginTwitter() {
        
        loginTwitter()
    }
    
    

}

