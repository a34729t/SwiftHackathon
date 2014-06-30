//
//  TwitterAPI.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/6/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import Accounts

class TwitterAPI : NSObject,NSURLSessionDataDelegate {
    enum TwitterAPIRequest : String {
        case GetOAuthRequestToken = "oauth/request_token"
        case GetOAuthAccessToken = "oauth/access_token"
        case Authenticate = "oauth/authorize"
        case GetHomeTimeline = "statuses/home_timeline.json"
        case Search = "search/tweets.json"
    }

    typealias CallbackFunction = (response : NSHTTPURLResponse?, data: NSData?, error: NSError?) -> ()

    let accounts = ACAccountStore()
    let APIVersion = "1.1"
    let DefaultAPIRoot = "https://api.twitter.com"

    var callbacks = Dictionary<NSURLSessionTask,CallbackFunction>()
    var urldata = Dictionary<NSURLSessionTask,NSMutableData>()
    var apiRoot : String!
    var account : ACAccount!
    var appToken : String?
    var appSecret : String?
    var authToken : String?
    var authSecret : String?
    var timeStamp : String {
        get {
            return String(UInt32(NSDate().timeIntervalSince1970))
        }
    }
    var nonce : String! {
        get {
            return NSUUID.UUID()?.UUIDString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false).base64Encoding()
        }
    }

    // make this a settable property for testing
    var oauth_headers : Dictionary<String,()->String!>!
    let characterSet : NSCharacterSet
    
    init()
    {
        apiRoot = DefaultAPIRoot
        oauth_headers = nil
        let escaped = "_-.~"
        let tempset = NSMutableCharacterSet.alphanumericCharacterSet()
        tempset.addCharactersInString(escaped)
        characterSet = tempset
        super.init()
        oauth_headers = ["consumer_key": { self.appToken }, "token": { self.authToken }, "signature_method": { "HMAC-SHA1" }, "timestamp": { self.timeStamp }, "nonce": { self.nonce }, "version": { "1.0" }]
    }

    var session : NSURLSession {
        get {
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            config.timeoutIntervalForResource = 180
            return NSURLSession(configuration:config, delegate:self, delegateQueue: queue)
        }
    }
    let queue : NSOperationQueue = NSOperationQueue()


    func _urlEncode(original : NSString) -> NSString
    {
        return original.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }

    func _baseString(baseParams : Dictionary<String,String>, request : NSURLRequest) -> String
    {
        let keys = sort(Array(baseParams.keys))
        var baseString = ""
        for (var key) in keys {
            if !baseString.isEmpty {
                baseString += "&"
            }
            baseString += "\(self._urlEncode(key))=\(self._urlEncode(baseParams[key]!))"
        }
        let pathURL = request.URL.scheme + "://" + request.URL.host + ((request.URL.port != nil && request.URL.port != 80 && request.URL.port != 443) ? ":\(request.URL.port)" : "") + request.URL.path
        baseString = request.HTTPMethod + "&" + _urlEncode(pathURL) + "&" + _urlEncode(baseString)
        NSLog("baseString %@", baseString)
        return baseString
    }

    func _signRequest(#request: NSURLRequest, params inParams: Dictionary<String,String>!)->NSURLRequest?
    {
        var params = Dictionary<String,String>()
        for (var k,v) in oauth_headers! {
            params["oauth_\(k)"] = v()
        }
        if inParams?["oauth_callback"] {
            params["oauth_callback"] = inParams["oauth_callback"]
        }
        // keep the oauth parameters separate since we'll need those for the header too
        var oauthParams = params

        if let inParamList = inParams {
            for (var k,v) in inParams {
                params[k] = v
            }
        }

        // Pull in the parameters from the query string
        if let components = request.URL.query?.componentsSeparatedByString("&") {
            for (var param) in components {
                let comps = param.componentsSeparatedByString("=")
                params[comps[0]] = comps[1]
            }
        }

        // If we're POST, also pull in the parameters from the body
        if request.HTTPMethod == "POST" && request.HTTPBody?.length > 0 {
            for (var param) in NSString(bytes:request.HTTPBody.bytes, length:request.HTTPBody.length, encoding:NSUTF8StringEncoding).componentsSeparatedByString("&") as Array<String> {
                let comps = param.componentsSeparatedByString("=")
                params[comps[0]] = comps[1]
            }
        }

        var baseString = self._baseString(params, request: request)

        var keyString = ((appSecret) ? appSecret! : "") + "&" + ((authSecret) ? authSecret! : "")
        NSLog("Key %@", keyString)
        let hmac = HMacEncoder(keyString: keyString)
        var signed = hmac.performEncoding(baseString)
        oauthParams["oauth_signature"] = signed.base64Encoding()

        let oauthKeys = sort(Array(oauthParams.keys))
        var headerString = ""
        for (var key) in oauthKeys {
            if (!headerString.isEmpty) {
                headerString += ", "
            }
            headerString += "\(self._urlEncode(key))=\"\(self._urlEncode(oauthParams[key]!))\""
        }
        headerString = "OAuth "+headerString
        var newRequest = request.mutableCopy() as NSMutableURLRequest
        newRequest.setValue(headerString, forHTTPHeaderField: "Authorization")
        NSLog("headers", newRequest.allHTTPHeaderFields)
        NSLog("header %@", headerString)

        return newRequest as NSURLRequest
    }

    func splitQueryString(query : NSString?) -> Dictionary<String,String>?
    {
        var returnParams : Dictionary<String,String>? = nil
        // Pull in the parameters from the query string
        if let components = query?.componentsSeparatedByString("&") {
            var params = Dictionary<String,String>()
            for (var param : AnyObject) in components {
                let comps = (param as String).componentsSeparatedByString("=")
                params[comps[0]] = comps[1]
            }
            returnParams = params
        }
        return returnParams
    }

    func urlForRequest(request: TwitterAPIRequest, parameters : Dictionary<String, String>!) -> NSURL?
    {
        let path = request.toRaw()
        var url : NSURL? = nil
        var urlString = ""

        if path.substringToIndex(5) == "oauth" {
            urlString = "\(apiRoot)/\(path)"
        } else {
            urlString = "\(apiRoot)/\(APIVersion)/\(path)"
        }
        if let params = parameters {
            var paramString = self._makeQueryString(params)
            if let bodyString = paramString {
                urlString += "?\(bodyString)"
            }
        }
        url = NSURL(string:urlString)
        return url
    }

    func twitterPostRequestWithResponse(request: TwitterAPIRequest, parameters : Dictionary<String, String>!, callback:CallbackFunction)
    {
        let url = self.urlForRequest(request,parameters: nil)
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "POST"
        if var bodyParams = parameters {
            if request == .GetOAuthRequestToken {
                bodyParams["oauth_callback"] = nil;
            }

            urlRequest.HTTPBody = self._makeQueryString(bodyParams)?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        }
        self.requestWithResponse(self._signRequest(request: urlRequest, params: parameters), callback: callback)
    }

    func twitterGetRequestWithResponse(request: TwitterAPIRequest, parameters : Dictionary<String, String>!, callback:CallbackFunction)
    {
        let url = self.urlForRequest(request,parameters: parameters)
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "GET"
        self.requestWithResponse(self._signRequest(request: urlRequest, params: nil), callback: callback)
    }

    func _makeQueryString(params: Dictionary<String, String>) -> String?
    {
        var bodyString = ""
        for (k,v) in params {
            if (!bodyString.isEmpty) {
                bodyString += "&"
            }
            bodyString += "\(self._urlEncode(k))=\(self._urlEncode(v))"
        }
        NSLog("body %@", bodyString)
        return bodyString
    }

    func requestWithResponse(let request : NSURLRequest?, callback : CallbackFunction)
    {
        if let urlRequest = request {
            NSLog("URLRequest: URL %@ Body %@ headers %@", urlRequest.URL, NSString(data:urlRequest.HTTPBody, encoding:NSUTF8StringEncoding), urlRequest.allHTTPHeaderFields)
            let task : NSURLSessionTask = session.dataTaskWithRequest(urlRequest)
            callbacks[task] = callback
            task.resume()
        }
    }

    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didCompleteWithError error: NSError!)
    {
        println("Task \(task) completed, error \(error)")
        let callback : CallbackFunction? = callbacks[task]
        callback?(response: task.response as? NSHTTPURLResponse, data: urldata[task], error: error)
        urldata[task] = nil
        callbacks[task] = nil
    }

    func URLSession(session: NSURLSession!, dataTask: NSURLSessionDataTask!, didReceiveResponse response: NSURLResponse!, completionHandler: ((NSURLSessionResponseDisposition) -> Void)!)
    {
        if let headers = (dataTask?.response as? NSHTTPURLResponse)?.allHeaderFields {
            let length = (headers["Content-Length"] as? String)?.toInt()
            if length {
                urldata[dataTask] = NSMutableData(capacity: length!)
            }
            completionHandler(.Allow)
        }
    }

    func URLSession(session: NSURLSession!, dataTask: NSURLSessionDataTask!, didReceiveData data: NSData!)
    {
        let mdata = urldata[dataTask]
        if !mdata {
            return
        }
        NSLog("data: %d bytes", data.length)
        var newData = NSMutableData(length: data.length)
        data.enumerateByteRangesUsingBlock() {
            (var pointer : CConstVoidPointer, range : NSRange, stop : CMutablePointer<ObjCBool>) in
            NSLog("Range: %ld len %ld", range.location, range.length)
            if range.location + range.length > newData.length {
                newData.increaseLengthBy(newData.length - range.location + range.length)
            }
            newData.replaceBytesInRange(range, withBytes: pointer, length: range.length)
        }
        mdata!.appendData(newData)
    }
}