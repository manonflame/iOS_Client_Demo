//
//  extension_window_forTopVC.swift
//  demo_FollowME
//
//  Created by 민경준 on 2018. 2. 23..
//  Copyright © 2018년 민경준. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    func topMostViewController() -> ChatRoomViewController? {
        guard let rootViewController = self.rootViewController else {
            return nil
        }
        return topViewController(for: rootViewController)
    }
    
    func topViewController(for rootViewController: UIViewController?) -> ChatRoomViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        guard let presentedViewController = rootViewController.presentedViewController else {
            if rootViewController.isKind(of: ChatRoomViewController.self){
                return rootViewController as! ChatRoomViewController
            }else{
                return nil
            }
            
        }
        switch presentedViewController {
        case is UINavigationController:
            let navigationController = presentedViewController as! UINavigationController
            return topViewController(for: navigationController.viewControllers.last)
        case is UITabBarController:
            let tabBarController = presentedViewController as! UITabBarController
            return topViewController(for: tabBarController.selectedViewController)
        default:
            return topViewController(for: presentedViewController)
        }
    }
}



