//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/8/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import Foundation

// to parse ErrorResponse
struct ErrorResponse: Codable {
    let status: Int
    let error: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
