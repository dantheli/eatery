//
//  AppDelegate.swift
//  Eatery
//
//  Created by Eric Appel on 10/5/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit
import Analytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var tools: Tools!
    
    //example slack info
    let slackChannel = "C04C10672"
    let slackToken = "xoxp-2342414247-2693337898-4405497914-7cb1a7"
    let slackUsername = "Keeper of All Your Base"
    
    //flag to enable tools
    let toolsEnabled = true

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions:  [NSObject: AnyObject]?) -> Bool {
        
        let URLCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(URLCache)
        
        print("Did finish launching", terminator: "")
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Set up view controllers
//        let eatNow = EatNowTableViewController()
        let eatNow = EateriesGridViewController()
        //eatNow.title = "Places To Eat"
        let eatNavController = UINavigationController(rootViewController: eatNow)
        eatNavController.navigationBar.barStyle = .Black
        
        window?.rootViewController = eatNavController
        window?.makeKeyAndVisible()
        
        let statusBarView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        statusBarView.backgroundColor = .eateryBlue()
        window?.rootViewController!.view.addSubview(statusBarView)
        
        // Segment setup
        SEGAnalytics.setupWithConfiguration(SEGAnalyticsConfiguration(writeKey: kSegmentWriteKey))
        let uuid = NSUUID().UUIDString
        SEGAnalytics.sharedAnalytics().identify(uuid)
        
        Analytics.trackAppLaunch()
        
        //declaration of tools remains active in background while app runs
        if toolsEnabled {
            tools = Tools(rootViewController: self.window!.rootViewController!, slackChannel: slackChannel, slackToken: slackToken, slackUsername: slackUsername)
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        Analytics.trackEnterForeground()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

