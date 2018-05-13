//
//  AppDelegate.swift
//  Feed Me More
//
//  Created by macbook on 12.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let vc = ViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = false
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}

