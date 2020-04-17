//
//  LocationResults.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/9/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import Foundation

// to unwrap StudentInformation to results
struct LocationResults: Codable {
    let results: [StudentInformation]
}
