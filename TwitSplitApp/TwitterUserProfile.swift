//
//  TwitterUserProfile.swift
//  TwitSplitApp
//
//  Created by khoa on 9/2/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import Foundation

struct TwitterUserProfile {
    
    var userID: String = ""
    var userName: String = ""
    var followersCount: Int = 0
    var friendsCount: Int = 0
    var profileBannerUrl: String = ""
    var profileImageUrl: String = ""
    var screenName: String = ""
    var statusesCount: Int = 0
    
    mutating func updateJsonData(json:Any) -> Void {
        
        print("json: \(json)")
        
        let jsonDict = json as? Dictionary<String, Any>
        
        if let userName = jsonDict?["name"] {
            self.userName = userName as! String
        }
        
        if let userName = jsonDict?["name"] {
            self.userName = userName as! String
        }
        
        if let followersCount = jsonDict?["followers_count"] {
            self.followersCount = followersCount as! Int
        }
        
        if let friendsCount = jsonDict?["friends_count"] {
            self.friendsCount = friendsCount as! Int
        }
        
        if let profileBannerUrl = jsonDict?["profile_banner_url"] {
            self.profileBannerUrl = profileBannerUrl as! String
        }
        
        if let profileImageUrl = jsonDict?["profile_image_url_https"] {
            self.profileImageUrl = profileImageUrl as! String
        }
        
        if let screenName = jsonDict?["screen_name"] {
            self.screenName = screenName as! String
        }
        
        if let statusesCount = jsonDict?["statuses_count"] {
            self.statusesCount = statusesCount as! Int
        }
    }
    
    mutating func renew() -> Void {
        self.userID = ""
        self.userName = ""
        self.followersCount = 0
        self.friendsCount = 0
        self.profileBannerUrl = ""
        self.profileImageUrl = ""
        self.screenName = ""
        self.statusesCount = 0
        
    }
}
