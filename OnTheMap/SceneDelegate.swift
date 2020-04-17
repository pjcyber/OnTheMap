//
//  SceneDelegate.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/7/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // Facebook
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let context = URLContexts.first else {
            return
        }
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: context.url,
            sourceApplication: context.options.sourceApplication,
            annotation: context.options.annotation
        )
    }
}
