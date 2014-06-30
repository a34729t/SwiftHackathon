//
//  twitter_swiftTests.swift
//  twitter_swiftTests
//
//  Created by Robert Diamond on 6/6/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import MiniPlatform
import XCTest

class twitter_swiftTests: XCTestCase {
    var api : TwitterAPI! = nil

    override func setUp() {
        super.setUp()
        api = TwitterAPI()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSign() {
        api.appSecret = "L8qq9PZyRg6ieKGEKhZolGC0vJWLw8iEJ88DRdyOg"
        api.appToken = "cChZNFj6T5R0TigYB9yd1w"
        api.oauth_headers = ["consumer_key": { self.api.appToken }, "token": { self.api.authToken }, "signature_method": { "HMAC-SHA1" }, "timestamp": {
            "1318467427" }, "nonce": { "ea9ec8429b68d6b77cd5600adbbb0456" }, "version": { "1.0" }]
        var request = NSMutableURLRequest(URL: NSURL(string: "https://api.twitter.com/oauth/request_token"))
        request.HTTPMethod = "POST"
        let newRequest = api._signRequest(request: request, params: ["oauth_callback": "http://localhost/sign-in-with-twitter/"])
        var headers = newRequest?.allHTTPHeaderFields?["Authorization"] as? NSString
        var loc = headers?.rangeOfString("F1Li3tvehgcraF8DMJ7OyxO4w9Y%3D")
        if let foundrange = loc {
            XCTAssertNotEqual(foundrange.location, NSNotFound, "Got bad signature", file: __FILE__, line: __LINE__)
        } else {
            XCTAssert(false, "bad headers", file: __FILE__, line: __LINE__)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
