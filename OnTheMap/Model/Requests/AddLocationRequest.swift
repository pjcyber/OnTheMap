//
//  AddLocationRequest.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/10/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import Foundation

struct LocationRequest: Codable {
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: URL?
    let uniqueKey: String
    
    init(latitude: Double, longitude: Double, mapString: String, mediaURL: URL?) {
        firstName = "Nikola"
        lastName = "Tesla"
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        uniqueKey = UdacityClient.Auth.accountKey

    }
}
