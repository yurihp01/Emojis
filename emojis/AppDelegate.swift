//
//  AppDelegate.swift
//  emojis
//
//  Created by Macbook on 31/03/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator()
        window?.rootViewController = appCoordinator.navigationController
        window?.makeKeyAndVisible()
        appCoordinator.start()
        
        return true
    }
}

