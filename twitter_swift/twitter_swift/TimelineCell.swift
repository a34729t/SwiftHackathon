//
//  TimelineCell.swift
//  twitter_swift
//
//  Created by Robert Diamond on 6/6/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import UIKit

class TimelineCell : UITableViewCell {
    
    @IBOutlet var userAvatar: UIImageView
    @IBOutlet var socialProofLabel: UILabel
    @IBOutlet var socialProofIcon: UIImageView
    @IBOutlet var userNameLabel: UILabel
    @IBOutlet var userHandleLabel: UILabel
    @IBOutlet var timeLabel: UILabel
    @IBOutlet var timeIcon: UIImageView
    @IBOutlet var tweetTextLabel: UILabel
    @IBOutlet var replyButton: UIButton
    @IBOutlet var retweetButton: UIButton
    @IBOutlet var favoriteButton: UIButton
    @IBOutlet var followButton: UIButton

    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
}
