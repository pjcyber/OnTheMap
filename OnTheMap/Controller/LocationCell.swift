//
//  LocationCell.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/8/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var mediaURL: UILabel!
    
    // setting cell values
    func setLocation(location: StudentInformation) {
        firstName.text = location.firstName
        mediaURL.text = location.mediaURL
    }
    
}
