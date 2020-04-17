//
//  HomeViewController.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/8/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkSeesion()
    }
}
