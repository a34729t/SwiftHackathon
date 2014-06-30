//
//  T1LoginViewController.swift
//  twitter_swift
//
//  Created by Robert Diamond on 6/17/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import MiniPlatform
import UIKit

class T1LoginViewController : UIViewController,TwitterDeepLinkable,UIWebViewDelegate,UIAlertViewDelegate {
    
    @IBOutlet var webView : UIWebView
    
    let api = TFNTwitter.sharedTwitter.twitterAPI
    var incomingURL : NSURL? = nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.webView.delegate = self
        let sharedApp = UIApplication.sharedApplication().delegate as AppDelegate
        api.appToken = sharedApp.apiKey;
        api.appSecret = NSString(data: sharedApp.apiSecret, encoding: NSUTF8StringEncoding)
        api.authSecret = nil
        api.authToken = nil
        if let url = incomingURL {
            NSLog("Processing URL %@", url)
            if let token = sharedApp.authToken {
                let queryParams = api.splitQueryString(url.query)
                if !queryParams?["oauth_token"].getLogicValue() || queryParams?["oauth_token"]! != token {
                        NSLog("Bad token or response: %@", (queryParams) ? queryParams! : "(nil)")
                } else {
                    api.authToken = sharedApp.authToken
                    api.authSecret = sharedApp.authSecret
                    if let oauth_verifier = queryParams?["oauth_verifier"] {
                        self._exchangeToken(oauth_verifier)
                    }
                }
            }
        }
    }

    func _exchangeToken(verifier : String)
    {
        api.twitterPostRequestWithResponse(.GetOAuthAccessToken, parameters: ["oauth_verifier": verifier]) {
            (response, data, error) in
            NSLog("got response %@", response!)
            if let authResponse = self.api.splitQueryString(NSString(data: data?, encoding: NSUTF8StringEncoding)) {
                let sharedApp = UIApplication.sharedApplication().delegate as AppDelegate
                sharedApp.authToken = authResponse["oauth_token"]
                sharedApp.authSecret = authResponse["oauth_token_secret"]
                var account = TFNTwitterAccount()
                account.authSecret = sharedApp.authSecret
                account.authToken = sharedApp.authToken
                account.userName = authResponse["screen_name"]
                if let userIDString = authResponse["user_id"] {
                    account.userID = (userIDString as NSString).longLongValue
                }
                TFNTwitter.sharedTwitter.currentAccount = account
                self.navigationController.popToRootViewControllerAnimated(true)
            }
        }
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        if (api.authToken == nil) {
            api.twitterPostRequestWithResponse(.GetOAuthRequestToken, parameters: ["oauth_callback": "twitter-swift://auth_response"]) {
                (response, data, error) in
                if error != nil {
                    self.loginFail(error!)
                } else {
                    NSLog("Got a response: %@", NSString(data: data, encoding:NSUTF8StringEncoding))
                    self._authorizeRequestKey(data)
                }
            }
        }
    }

    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
    }

    func loginFail(error : NSError)
    {
        var a = UIAlertController(title: "Login flow failed", message: error.localizedDescription, preferredStyle: .Alert)
        a.addAction(UIAlertAction(title: "Ok", style: .Cancel) { (action) in
            a.dismissViewControllerAnimated(true, completion: nil)
            })
        self.presentViewController(a, animated: true, completion: nil)
    }

    func _authorizeRequestKey(data : NSData?)
    {
        var oauth_token : String? = nil
        var oauth_secret : String? = nil
        if let paramData = data {
            var params = NSString(data: paramData, encoding: NSUTF8StringEncoding)
            for (var param) in params.componentsSeparatedByString("&") as Array<String> {
                var comps = param.componentsSeparatedByString("=") as Array<String>
                switch (comps[0]) {
                    case "oauth_token": oauth_token = comps[1]
                    case "oauth_token_secret": oauth_secret = comps[1]
                default:
                    NSLog("Got \(comps[0])=%@", (comps.count > 1) ? comps[1] : "(nil)")
                }
            }
        }
        if oauth_secret == nil || oauth_token == nil {
            var error = NSError(domain: "Login", code: 0, userInfo: [NSLocalizedDescriptionKey: "Didn't receive token and secret"])
            self.loginFail(error)
            return
        }
        self.webView.hidden = false;
        api.authToken = oauth_token
        api.authSecret = oauth_secret
        let sharedApp = UIApplication.sharedApplication().delegate as AppDelegate
        sharedApp.authToken = oauth_token
        sharedApp.authSecret = oauth_secret
        var url = api.urlForRequest(TwitterAPI.TwitterAPIRequest.Authenticate, parameters: ["oauth_token": oauth_token!])
        self.webView.loadRequest(NSURLRequest(URL: url))
        self.view.setNeedsLayout()
    }

    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool
    {
        NSLog("About to load %@ type %d", request.URL, navigationType.toRaw())
        return true
    }
}
