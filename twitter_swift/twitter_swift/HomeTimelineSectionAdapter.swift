//
//  HomeTimelineSectionAdapter.swift
//  twitter_swift
//
//  Created by Robert Diamond on 6/29/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import MiniPlatform

class HomeTimelineSectionAdapter : SectionAdapter {
    override func sectionArray(inArray: Array<Identifiable>?) -> Array<Array<Identifiable>>?
    {
        if inArray.getLogicValue() == false || inArray?.count == 0 {
            // Empty, just return nothing
            return [[]];
        }
        if inArray![0].ID < 0 {
            // Error, etc: just pass it through
            return [inArray!]
        }
        // otherwise, tack on a PTR and a footer (we'll deal with gaps later)
        var sections = Identifiable[]()
        sections.append(PTRItem())
        sections.extend(inArray!)
        sections.append(FooterItem())
        return [sections]
    }
}
