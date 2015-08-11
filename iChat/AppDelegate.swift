//
//  AppDelegate.swift
//  iChat
//
//  Created by Charles Gong on 5/28/15.
//  Copyright (c) 2015 Charles Gong. All rights reserved.
//

import UIKit
import Parse
import Bolts
import LayerKit


public let LayerAppIDString = "layer:///apps/staging/82be69ca-4063-11e5-8298-5b167101541c"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LYRClientDelegate {

    var window: UIWindow?
    var layerClient: LYRClient!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.setApplicationId("diR324n1rVjjXANPEOSDNHU7kQ8JqRWbyHLnJJkh", clientKey: "Sl9Sde3uhBigZu1xy6p2XAz1gJA1Cup6QXMSBgcW")
        
        var appID: NSURL!
        appID = NSURL(fileURLWithPath: LayerAppIDString)
        layerClient = LYRClient(appID: appID)
        layerClient.delegate = self
        layerClient.autodownloadMIMETypes = NSSet(
        
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
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: Layer Authentication Methods
    
    func authenticateLayerWithUserID(userID: String, completion: (success: Bool, error: NSError?) -> Void)
    {
    
    }
    
    
    //MARK: Layer Client Delegate Methods
    
    func layerClient(client: LYRClient!, didReceiveAuthenticationChallengeWithNonce nonce: String!) {
        println("Layer Client did recieve authentication challenge with nonce: \(nonce)")
    }
    
    func layerClient(client: LYRClient!, didAuthenticateAsUserID userID: String!) {
        println("Layer Client did recieve authentication nonce");
    }
    
    func layerClientDidDeauthenticate(client: LYRClient!) {
        println("Layer Client did deauthenticate")
    }
    


}

