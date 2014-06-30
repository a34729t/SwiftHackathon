//
//  ViewController.swift
//  SwiftMirror
//
//  Created by Doug Whitmore on 6/27/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

import UIKit
import Accounts
import Social

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

    func composeFinalImage() -> UIImage? {
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        self.imageView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let contextImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // for testing 
        return contextImage
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
            println("facial features found: \(features)")
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

    @IBAction func save(sender: AnyObject) {
        if let composedImage = composeFinalImage() {
            let accountStore = ACAccountStore()
            let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            accountStore.requestAccessToAccountsWithType(twitterAccountType) {
                granted, error in
                if granted {
                    println("booyah")
                    let accounts = accountStore.accountsWithAccountType(twitterAccountType)
                    let urlString = "https://api.twitter.com/1.1/statuses/update_with_media.json"
                    var params:NSDictionary = ["status":"Hello from #SwiftMirror"]
                    let req = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, URL: NSURL(string: urlString), parameters: params)
                    
                    let requestHandler:SLRequestHandler = { data, res, error in
                        if res.statusCode > 199 && res.statusCode < 300 {
                            println("Woot")
                            let responseDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil) as? NSDictionary
                            println("Tweet saved with tweet id: \(responseDict.description)")
                        } else {
                            println("error sedning tweet - \(res.statusCode): \(error)")
                        }
                    }
                    
                    let imageData = UIImageJPEGRepresentation(composedImage, 1.0)
                    req.addMultipartData(imageData, withName: "media[]", type: "image/jpeg", filename: "image.jpeg")
                    req.account = accounts[0] as ACAccount
                    req.performRequestWithHandler(requestHandler)
                } else {
                    println("Can't access account! Save to library instead")
                    UIImageWriteToSavedPhotosAlbum(composedImage, nil, nil, nil)
                }
            }
        } else {
            UIAlertView(title: "Oops", message: "Unable to compose the image", delegate: nil, cancelButtonTitle: "OK")
        }
    }

    func imagePickerController(controller:UIImagePickerController, didFinishPickingImage image:UIImage, editingInfo:NSDictionary) {
        controller.dismissModalViewControllerAnimated(true)
        imageView.image = image
    }
}

