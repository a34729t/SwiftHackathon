//
//  RowAdapterFactory.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/28/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

class RowAdapterFactory : NSObject {
    func adapters() -> Dictionary<String,RowAdapter>?
    {
        return Dictionary<String,RowAdapter>()
    }
}