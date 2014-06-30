//
//  SectionAdapter.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/24/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import Foundation

class SectionAdapter : NSObject {

    func sectionArray(Array<Identifiable>?) -> Array<Array<Identifiable>>?
    {
        // default implementation does nothing
        return nil
    }
}