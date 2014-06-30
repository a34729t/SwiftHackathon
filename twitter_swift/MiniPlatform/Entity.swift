//
//  Entity.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/21/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import Foundation

enum EntityType {
    case Url(String, NSURL, NSURL), Description(String, NSURL, NSURL)
    case Image(NSURL)
    case Hashtag(String), UserMention(User), StockSymbol(String)
}

class Entity : NSObject {
    var entityType : EntityType
    var indices : NSRange

    init(type:EntityType, _indices:NSRange)
    {
        entityType = type
        indices = _indices
        super.init()
    }
}