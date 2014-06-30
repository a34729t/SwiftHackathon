//
//  T1AppNavigationDelegate.swift
//  twitter_swift
//
//  Created by Robert Diamond on 6/16/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import MiniPlatform
import UIKit

class T1AppNavigationDelegate : NSObject,UITabBarControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var navigationController : UINavigationController
    {
        didSet {
            NSLog("navbar set")
            self.tabBarController = navigationController.viewControllers[0] as? UITabBarController
        }
    }
    
    var tabBarController : UITabBarController?
    {
        didSet {
            NSLog("tab controller set")
            if (tabBarController?.viewControllers.count > 0) {
                self.loginIfNeeded(fromViewController: tabBarController?.viewControllers[0] as UIViewController)
            }
        }
    }
    init()
    {
        NSLog("created a navdelegate")
        super.init()
        (UIApplication.sharedApplication().delegate as AppDelegate).tabBarControllerDelegate = self
    }

    deinit
    {
        NSLog("goodbye cruel world")
    }

    func loginIfNeeded(fromViewController viewController: UIViewController!)
    {
        if TFNTwitter.sharedTwitter.currentAccount == nil {
            dispatch_async(dispatch_get_main_queue()) {
                var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                var loginVC : T1LoginViewController! = storyBoard.instantiateViewControllerWithIdentifier("login") as T1LoginViewController
                viewController?.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }

    func tabBarController(tabBarController: UITabBarController!, didEndCustomizingViewControllers viewControllers: AnyObject[]!, changed: Bool)
    {
        NSLog("customized")
    }

    func tabBarController(tabBarController: UITabBarController!, didSelectViewController viewController: UIViewController!)
    {
        NSLog("selected %@", viewController)
    }
}