//
//  AppDelegate.swift
//  twitter_swift
//
//  Created by Robert Diamond on 6/6/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import MiniPlatform
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // TODO: Obfuscate these somehow
    let apiKey = "7ly508IjQeZ38OUvuhTe0WaG0"
    let apiSecret = NSData(base64EncodedString:"QzVGMzdwWDY4VG8waXJpOElSaWxqOGY1TVlySWVNNTlWWklUUkdzSEZWNVJYa2NyYjI=", options:.IgnoreUnknownCharacters)

    var authToken : String?
    var authSecret : String?

    var window: UIWindow?
    var tabBarControllerDelegate:T1AppNavigationDelegate?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        TFNTwitter.sharedTwitter.twitterAPI.appToken = apiKey
        TFNTwitter.sharedTwitter.twitterAPI.appSecret = NSString(data: apiSecret, encoding:NSUTF8StringEncoding)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication!, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool
    {
        if let scheme = url?.scheme {
            if (scheme == "twitter-swift") {
                return DeepLinkHandler().handleURL(url!)
            }
        }
        return false
    }
}

