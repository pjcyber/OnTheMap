//
//  LocationItem.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/9/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import Foundation

class StudentInformation: NSObject, Codable {
    
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let createdAt: String
    let updatedAt: String
    
    init(firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String,
         mediaURL: String, objectId: String, uniqueKey: String, createdAt: String, updatedAt: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
