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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func takePicture(sender: AnyObject?) -> () {
        let picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.cameraDevice = .Front
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
    }

    func imagePickerController(controller:UIImagePickerController, didFinishPickingImage image:UIImage, editingInfo:NSDictionary) {
        controller.dismissModalViewControllerAnimated(true)
        imageView.image = image
    }
}

