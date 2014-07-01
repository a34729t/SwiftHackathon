//
//  TimelineViewController.swift
//  twitter_swift
//
//  Created by Robert Diamond on 6/6/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import UIKit
import MiniPlatform

class TimelineViewController : TFNTableViewController {
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.stream = HomeTimelineStream()
        self.sectionAdapter = HomeTimelineSectionAdapter()
        // Can't just say Tweet here since it'll be a mangled Swift name
        var newRowAdapters : Dictionary<String,RowAdapter> = RowAdapterFactory().adapters()
        newRowAdapters[NSString(CString: class_getName(Tweet))] = StatusRowAdapter(reuseIdentifier: "StatusCell")
        self.rowAdapters = newRowAdapters
    }

}