//
//  DeepLinkHandler.swift
//  twitter_swift
//
//  Created by Robert Diamond on 6/20/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import Foundation
import MiniPlatform
import UIKit

class DeepLinkHandler : NSObject {
    let linkmap = ["auth_response": "login"]

    func handleURL(url: NSURL) -> Bool
    {
        NSLog("host %@ path %@ query %@", url.host, url.path, url.query)
        if let storyBoardID = linkmap[url.host.lowercaseString] {
            if let navController = UIApplication.sharedApplication().delegate.window?.rootViewController as? UINavigationController {
                navController.popToRootViewControllerAnimated(false)
                let storyBoard = navController.storyboard

                var viewController = storyBoard.instantiateViewControllerWithIdentifier(storyBoardID) as? UIViewController
                if let deepLinkable = viewController as? TwitterDeepLinkable {
                    deepLinkable.incomingURL = url
                }
                if let vc = viewController {
                    navController.pushViewController(viewController, animated: false)
                    return true
                }
            }
        }
        return false
    }
}