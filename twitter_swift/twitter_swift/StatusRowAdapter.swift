//
//  StatusRowAdapter.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/27/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import MiniPlatform
import UIKit

class StatusRowAdapter : RowAdapter {
    func cellForItem(item : Identifiable,tableView : UITableView) -> UITableViewCell?
    {
        var cell : TimelineCell = tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier) as TimelineCell
        let tweet = item as Tweet
        cell.userAvatar.image = UIImage(data:NSData(contentsOfURL:tweet.user?.profileImageURL))
        cell.tweetTextLabel.attributedText = self._attributedTextForTweet(tweet)

        return cell
    }

    func didSelectItem(item : Identifiable,tableView : UITableView)
    {

    }

    func _attributedTextForTweet(tweet: Tweet) -> NSAttributedString?
    {
        var value = NSMutableAttributedString(string:tweet.text)
        if let entityArray = tweet.entities {
            for entity in entityArray {
                value.setAttributes([NSForegroundColorAttributeName: UIColor.blueColor()], range: entity.indices)
            }
        }

        return value
    }
}
