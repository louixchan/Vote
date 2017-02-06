//
//  AppDelegate.swift
//  Vote
//
//  Created by Chan Lo Yuet on 25/1/2017.
//  Copyright © 2017 Louis. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate {

    var window: UIWindow?

    //Following functions are never called, but the delegate has to inherit FBSDKLoginButtonDelegate hence has to be implemented
    // Function 1
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("Facebook functino in delegate")
        if (error == nil) {
        } else {
            print(error.localizedDescription)
            return
        }
    }
    // Function 2
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("FB: User logged out...")
    }
    
    // ENDS HERE
    
    // For opening URL for 3rd part login as of now
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app,open: url,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        /* If sign in with google, return the following 
            return GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,annotation: [:])
           If sign in with facebook, return the following
            return FBSDKApplicationDelegate.sharedInstance().application(app,open: url,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        */
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        
        // For google login
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // Comment for google login functionality testing
        // Copied this to viewDidLoad so you can continue testing in mainVC
        //FIRAuth.auth()?.signIn(withEmail: "testing@gmail.com", password: "123456")
        
        // Override point for customization after application launch.
        return true
    }

    
    //  Google Sign in Step 5. Implement the GIDSignInDelegate protocol to handle the sign-in process
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // error
            print ("Error signing in with Google: %@", error)
            return
        } else {
            // No error
            print ("No error implementing GIDSignInDelegate protocol")
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        // ...
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if let error = error {
                // error
                print ("Error linking Google token to firebase auth: %@", error)
                return
            } else {
                // No error
                print ("No error implementing Firebase Auth with token from Google ")
            }
        }
    }
            
    // Handle Google Sign in disconnection
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
            // Perform any operations when the user disconnects from app here.
            // ...
        }
    

    // Any thing below is unchanged 
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}



