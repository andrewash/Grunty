//
//  AppDelegate.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.backgroundColor = UIColor.cyan
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()

        return true
    }
    
}

