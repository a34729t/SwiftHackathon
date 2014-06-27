//
//  FlairView.swift
//  SwiftMirror
//
//  Created by Doug Whitmore on 6/27/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

import UIKit

class FlairView: UIImageView {

    var lastCenter:CGPoint = CGPointMake(0.0, 0.0)

    init(frame:CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "handleGesture:")
        self.gestureRecognizers = [panRecognizer]
    }

    func handleGesture(recoginzer: UIPanGestureRecognizer) -> () {
        let translation = recoginzer.translationInView(self.superview)
        self.center = CGPointMake(lastCenter.x + translation.x, lastCenter.y + translation.y)
    }

    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        lastCenter = self.center
    }
}
