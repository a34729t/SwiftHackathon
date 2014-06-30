//
//  TFNTableViewController.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/24/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import Foundation
import UIKit

class TFNTableViewController<SectionAdapterType : SectionAdapter, RowAdapterFactory : RowAdapterFactory, StreamType : Stream> : UITableViewController {
    @lazy var stream = StreamType()
    @lazy var rowAdapters = RowAdapterFactory().adapters()
    @lazy var sectionAdapter = SectionAdapterType()
    var minID : Int64?
    var maxID : Int64?
    
    var sections : Array<Array<Identifiable>>?
    {
    didSet {
        self.tableView.reloadData()
    }
    }

    override func viewDidLoad()
    {
        // TODO: install default row adapters, e.g. String
        super.viewDidLoad()
    }

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return (sections) ? sections!.count : 0
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        if sections.getLogicValue() && section < sections!.count {
            return sections![section].count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        var cell : UITableViewCell? = nil;
        if sections?.count > indexPath.section && sections![indexPath.section].count > indexPath.row {
            let item : Identifiable = sections![indexPath.section][indexPath.row]
            let itemClass = NSString(CString: class_getName((item as AnyObject).dynamicType))
            if rowAdapters[itemClass].getLogicValue() {
                cell = rowAdapters[itemClass]!.cellForItem(item,tableView)
            }
        }

        return cell
    }

    func update()
    {
        self.sections = self.sectionAdapter.sectionArray(self.stream.streamObjects)
    }
    
    func loadTop()
    {
        
        stream.loadTop() {
            (results : AnyObject?, error : NSError?) in
            self.update()
        }
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.loadTop()
    }
}
