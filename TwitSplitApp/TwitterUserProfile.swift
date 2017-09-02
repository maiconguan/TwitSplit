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
        
        self.userName           = jsonDict?["name"] as! String
        self.followersCount     = jsonDict?["followers_count"] as! Int
        self.friendsCount       = jsonDict?["friends_count"] as! Int
        self.profileBannerUrl   = jsonDict?["profile_banner_url"] as! String
        self.profileImageUrl    = jsonDict?["profile_image_url_https"] as! String
        self.screenName         = jsonDict?["screen_name"] as! String
        self.statusesCount      = jsonDict?["statuses_count"] as! Int

        
    }
}
