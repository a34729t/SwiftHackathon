//
//  TwitterDeepLinkable.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/20/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import UIKit

@objc protocol TwitterDeepLinkable {
    var incomingURL : NSURL? { get set }
}
