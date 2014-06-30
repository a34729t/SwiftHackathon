//
//  Stream.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/21/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import Foundation

typealias CompletionFunction = (results : AnyObject?, error : NSError?) -> Void
class Stream : NSObject {
    let STREAM_ERROR_DOMAIN = "stream"
    var streamObjects : Array<Identifiable>
    var error : NSError?
    var api : TwitterAPI?

    init()
    {
        streamObjects = Array<Identifiable>()
        super.init()
    }

    /**
     * Returns the smallest ID in streamObjects
     */
    func minID() -> Int64?
    {
        return streamObjects.reduce(nil) {
            (minValue : Int64?, element) in
            return (!minValue.getLogicValue() || element.ID < minValue!) ? element.ID : minValue
        }
    }

    func maxID() -> Int64?
    {
        return streamObjects.reduce(nil) {
            (maxValue : Int64?, element) in
            return (!maxValue.getLogicValue() || element.ID > maxValue!) ? element.ID : maxValue
        }
    }

    func load(#minID : Int64?, maxID : Int64?, completion : CompletionFunction)
    {
        // does nothing, implemented in subclasses
    }

    func loadTop(completion : CompletionFunction)
    {
        self.load(minID: self.maxID(), maxID: nil, completion: completion)
    }

    func loadBottom(completion : CompletionFunction)
    {
        self.load(minID: nil, maxID: self.minID(), completion: completion)
    }
}