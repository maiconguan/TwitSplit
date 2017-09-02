//
//  Helper.swift
//  TwitSplitApp
//
//  Created by khoa on 9/1/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import Foundation

class Helper {
    static func localizedString(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    static func saveSetting(reversePostingOrder:Bool, omittingEmptySequence: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(reversePostingOrder, forKey: Contants.SettingKeys.kReversePostingOrder)
        defaults.set(omittingEmptySequence, forKey: Contants.SettingKeys.kOmittingEmptySequence)
    }
    
    static func loadSetting() -> [Bool] {
        let defaults = UserDefaults.standard
        return [defaults.bool(forKey: Contants.SettingKeys.kReversePostingOrder), defaults.bool(forKey: Contants.SettingKeys.kOmittingEmptySequence)]
    }
}
