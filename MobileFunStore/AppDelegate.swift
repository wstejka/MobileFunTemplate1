//
//  AppDelegate.swift
//  MobileFunStore
//
//  Created by Wojciech Stejka on 09/10/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import Firebase
import SwiftyBeaver

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // ============== Set up SwiftyBeaver  =================== //
        // add log destinations. at least one is needed!
        let console = ConsoleDestination()  // log to Xcode Console
        // use custom format and set console output to short time, log level & message
        console.format = "$Dyyyy-MM-dd HH:mm:ss$d $L [$N:$l $F] $M"
        // add the destinations to SwiftyBeaver
        log.addDestination(console)
        // That's the workaround to not engage whole functionallity (especially UI part) in UT activities
        // Return if this is a unit test
        if let _ = NSClassFromString("XCTest") {
            log.verbose("========== UNIT TESTING ==============")
            return true
        }
        
        
        FirebaseApp.configure()        
        
//        Database.database().isPersistenceEnabled = false
//        let settings = FirestoreSettings()
//        settings.dispatchQueue = DispatchQueue.main
//        settings.isSSLEnabled = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

