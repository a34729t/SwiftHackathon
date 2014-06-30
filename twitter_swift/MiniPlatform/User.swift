//
//  User.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/21/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import Foundation

class User : NSObject,Identifiable {
    let CONTRIBUTORS_ENABLED_KEY = "contributors_enabled"
    let CREATED_AT_KEY = "created_at"
    let DESCRIPTION_KEY = "description"
    let PROFILE_IMAGE_URL_KEY = "profile_image_url_https"

    var ID : Int64 = 0
    var contributorsEnabled : Bool = false
    var createdAt : NSDate?
    var userDescription : String!
    var entities : Array<Entity>?
    var favorites : Int = 0
    var followers : Int = 0
    var following : Int = 0
    var followRequestSentByUser : Bool = false
    var followedByUser : Bool = false
    var friends : Int = 0
    var geoEnabled : Bool = false
    var userID : Int64 = 0
    var locale : String!
    var listedCount : Int = 0
    var location : Place?
    var name : String!
    var notificationsToUser : Bool = false
    var profileImageURL : NSURL?
    var profileBackgroundColor : UIColor?
    var profileBackgroundImage : NSURL?
    var tileBackgroundImage : Bool = false
    var profileLinkColor : UIColor?
    var profileSidebarFillColor : UIColor?
    var profileTextColor : UIColor?
    var profileUseBackgroundImage : Bool = false
    var protected : Bool = false
    var screenName : String!
    var statusCount : Int = 0
    var timeZone : String!
    var url : NSURL?
    var utcOffset : Int = 0
    var verified : Bool = false

}