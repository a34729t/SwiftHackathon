//
//  FlairManager.swift
//  SwiftMirror
//
//  Created by Doug Whitmore on 6/27/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

import UIKit

class FlairManager {
    var flairImages = Array<UIImage>()

    init() {
        let imageNames = ["crown1", "crown2", "moustache1", "moustache2", "moustache3", "moustache4", "moustache5", "moustache6", "moustache7", "moustache8"];
        flairImages = imageNames.map {
            (name:String) -> (UIImage) in
            return UIImage(named: name)
        }
    }

    func getAnImage() -> (UIImage) {
        let imageIndex = (random() % flairImages.count)
        return flairImages[imageIndex]
    }
}

var sharedFlairManager = FlairManager()