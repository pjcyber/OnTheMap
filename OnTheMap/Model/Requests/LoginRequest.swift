//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/8/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    
    let udacity: Udacity
    
}

struct Udacity: Codable {
    
    let username: String
    let password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
