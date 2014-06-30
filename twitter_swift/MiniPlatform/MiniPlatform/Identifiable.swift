//
//  Identifiable.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/23/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import Foundation

/**
 * anything with an ID field
 */
@objc protocol Identifiable {
    var ID : Int64 { get set }
}