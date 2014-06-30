//
//  TFNTwitter.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/16/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import Foundation

struct TFNTwitter {
    let accountKey = "TFNTwitterAccountKey"

    static var sharedTwitter : TFNTwitter = TFNTwitter()
    var twitterAPI  = TwitterAPI()
    var currentAccount : TFNTwitterAccount? = nil
    {
        didSet {
            NSUserDefaults.standardUserDefaults()?.setValue(currentAccount?.asDictionary(), forKey: accountKey)
            self._setupKey()
        }
    }

    init()
    {
        currentAccount = TFNTwitterAccount(dictionary: (NSUserDefaults.standardUserDefaults()).valueForKey(accountKey) as? Dictionary)
        self._setupKey()
    }

    func _setupKey()
    {
        twitterAPI.authToken = nil
        twitterAPI.authSecret = nil
        twitterAPI.authToken = currentAccount?.authToken
        twitterAPI.authSecret = currentAccount?.authSecret
    }
}