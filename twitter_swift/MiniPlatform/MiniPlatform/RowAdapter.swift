//
//  RowAdapter.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/26/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import Foundation
import UIKit

/**
 * Pluggables to handle cells in multiple view controllers
 */
class RowAdapter : NSObject {
    var cellReuseIdentifier : String!

    func cellForItem(Identifiable,UITableView) -> UITableViewCell?
    {
        // handled in subclass
        return nil
    }

    func didSelectItem(Identifiable,UITableView)
    {

    }

    init(reuseIdentifier : String)
    {
        super.init()
        self.cellReuseIdentifier = reuseIdentifier
    }
}
