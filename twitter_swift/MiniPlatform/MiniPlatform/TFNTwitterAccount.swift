//
//  TFNTwitterAccount.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/16/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import Foundation

class TFNTwitterAccount : NSObject {
    let USER_NAME_KEY = "userName"
    let USER_ID_KEY = "userID"
    let AUTH_TOKEN_KEY = "authToken"
    let AUTH_SECRET_KEY = "authSecret"

    var userName : String?
    var userID : Int64?
    var authToken : String?
    var authSecret : String?

    init(dictionary someDict: Dictionary<String,String>!)
    {
        if let dictionary = someDict {
            userName = dictionary[USER_NAME_KEY]
            if let userIDStr : NSString = dictionary[USER_ID_KEY] {
                userID = userIDStr.longLongValue
            }
            authToken = dictionary[AUTH_TOKEN_KEY]
            authSecret = dictionary[AUTH_SECRET_KEY]
        }
    }

    convenience init()
    {
        self.init(dictionary: nil)
    }

    func asDictionary() -> Dictionary<String,String>
    {
        var dictionary = Dictionary<String,String>()
        dictionary[USER_NAME_KEY] = userName
        if let userIDValue = userID {
            dictionary[USER_ID_KEY] = String(userIDValue)
        }
        dictionary[AUTH_TOKEN_KEY] = authToken
        dictionary[AUTH_SECRET_KEY] = authSecret

        return dictionary
    }
}