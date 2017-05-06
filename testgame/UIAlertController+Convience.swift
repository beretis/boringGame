//
//  UIAlertController+Convience.swift
//  testgame
//
//  Created by Jozef Matus on 06/05/2017.
//  Copyright © 2017 Jozef Matus. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    @nonobjc static func alert(_ title: String?, message: String?, OKActionTitle: String? = nil, cancelActionTitle: String? = nil, destructiveActionTitle: String? = nil, OKAction: ((UIAlertAction) -> ())? = nil, cancelAction: ((UIAlertAction) -> ())? = nil, destructiveAction: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let cancelActionTitle = cancelActionTitle {
            
            let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel) {
                (action) in
                
                if let cancelAction = cancelAction {
                    cancelAction(action)
                }
            }
            alertController.addAction(cancelAction)
        }
        
        if let destructiveActionTitle = destructiveActionTitle {
            
            let destructiveAction = UIAlertAction(title: destructiveActionTitle, style: .destructive) {
                (action) in
                if let destructiveAction = destructiveAction {
                    destructiveAction(action)
                }
            }
            alertController.addAction(destructiveAction)
        }
        
        if destructiveActionTitle == nil {
            
            let OKAction = UIAlertAction(title: OKActionTitle ?? "general.ok", style: .default) {
                (action) in
                if let OKAction = OKAction {
                    OKAction(action)
                }
            }
            alertController.addAction(OKAction)
        }
        
        return alertController
    }
    
    
    func show(_ fromViewController: UIViewController? = nil) {
        if let controller = fromViewController {
            controller.present(self, animated: true, completion: nil)
            return
        }
        if let rootVC = UIApplication.shared.windows[0].rootViewController, rootVC.presentedViewController != nil {
            rootVC.presentedViewController?.present(self, animated: true, completion: nil)
        }
        else {
            UIApplication.shared.windows[0].rootViewController?.present(self, animated: true, completion: nil)
        }
    }
    
    
}
