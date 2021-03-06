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
    var dataStore = DataStore()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // dependency injection
        let viewModel = PostsViewModel(dataStore: dataStore)
        let mainVC = PostsTableViewController(viewModel: viewModel)

        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = UINavigationController(rootViewController: mainVC)
        window?.makeKeyAndVisible()

        return true
    }

}
