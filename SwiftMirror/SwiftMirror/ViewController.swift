//
//  ViewController.swift
//  SwiftMirror
//
//  Created by Doug Whitmore on 6/27/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
                            
    @IBOutlet var imageView: UIImageView
    @IBOutlet var saveButton: UIBarButtonItem

    var flair: FlairView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func camera(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            picker.sourceType = .Camera
            picker.cameraDevice = .Front
        } else {
            picker.sourceType = .PhotoLibrary
        }
        self.presentModalViewController(picker, animated: true)
    }
    
    @IBAction func addFlair(sender: AnyObject) {
        if let anImage = imageView.image  {
            let aCIImage = CIImage(image: anImage)
            let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: nil)
            let features = detector.featuresInImage(aCIImage)
            println("features: \(features)")
        }
        if let someFlair = flair {
            someFlair.removeFromSuperview()
        }
        // find center
        let centerX = imageView.frame.size.width / CGFloat(2.0)
        let centerY = imageView.frame.size.height / CGFloat(2.0)
        let flairImage = sharedFlairManager.getAnImage()
        let width = CGFloat(100.0)
        let widthScale = flairImage.size.width / width
        let height = flairImage.size.height / widthScale
        let originX = centerX - width / CGFloat(2.0)
        let originY = centerY - (height / CGFloat(2.0))
        let imageFrame = CGRectMake(originX, originY, width, height)

        flair = FlairView(frame:imageFrame)
        flair!.image = flairImage
        imageView.addSubview(flair)
    }

    func imagePickerController(controller:UIImagePickerController, didFinishPickingImage image:UIImage, editingInfo:NSDictionary) {
        controller.dismissModalViewControllerAnimated(true)
        imageView.image = image
    }
}

