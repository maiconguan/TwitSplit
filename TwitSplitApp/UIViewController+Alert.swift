//
//  UIViewController+Alert.swift
//  TwitSplitApp
//
//  Created by khoa on 9/1/17.
//  Copyright © 2017 Mai Cong Uan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(titleKey: String, messageKey: String = "") {
        DispatchQueue.main.async {
            self.alert(titleKey: titleKey, messageKey: messageKey)
        }
    }
    
    private func alert(titleKey: String, messageKey: String = "") {
        let alertController = UIAlertController(title: Helper.localizedString(key: titleKey) , message:  Helper.localizedString(key: messageKey), preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
