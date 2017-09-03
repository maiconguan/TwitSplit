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
    
    func showAlert(titleKey: String, messageKey: String, _ msgArgs: [CVarArg]) {
        DispatchQueue.main.async {
            self.alert(titleKey: titleKey, messageKey: messageKey, msgArgs)
        }
    }
    
    private func alert(titleKey: String, messageKey: String, _ msgArgs: [CVarArg]) {

        let message = withVaList(msgArgs) { Helper.localizerFunction()(messageKey, $0) }

        let alertController = UIAlertController(title: Helper.localizedString(key: titleKey) , message:  message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
