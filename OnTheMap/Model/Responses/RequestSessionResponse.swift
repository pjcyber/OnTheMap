//
//  RequestSessionResponse.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/8/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import Foundation

// to parse RequestSessionResponse
struct RequestSessionResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let key: String
    let registered: Bool
}

struct Session: Codable {
    let id: String
    let expiration: String
}
