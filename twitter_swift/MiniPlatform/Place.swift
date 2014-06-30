//
//  Place.swift
//  MiniPlatform
//
//  Created by Robert Diamond on 6/21/14.
//  Copyright (c) 2014 Robert Diamond. All rights reserved.
//

import Foundation
import MapKit

class Place : NSObject {
    var coordinate : CLLocation
    var name : String

    init(coord: CLLocation, placeName: String)
    {
        coordinate = coord
        name = placeName
        super.init()
    }
}