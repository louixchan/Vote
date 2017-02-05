//
//  LoginViewController.swift
//  Vote
//
//  Created by Ching Kim Fu Cliff on 2/4/17.
//  Copyright © 2017 Louis. All rights reserved.
//

import Foundation

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit


class LoginViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {

    // Facebook login compulsory function for FBSDKLoginButtonDelegate
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (error == nil) {
            print("Facebook no error")
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                // ...
                if let error = error {
                    // error
                    print ("Error linking FB token tofirebase auth: %@", error)
                    return
                } else {
                    // No error
                    print ("No error implementing Firebase Auth with token from FB ")
                }
            }
        } else {
            print("Facebook Error: ")
            print(error.localizedDescription)
            return
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("FB: User logged out...")
    }


    
    var newEmail:String!
    var newPW:String!
    
    @IBOutlet weak var newEmailInput: UITextField!
    @IBOutlet weak var newPWInput: UITextField!
    @IBOutlet weak var GoogleSignInButton: GIDSignInButton!

    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // Signout the account from mainVC
        modelSignOut()
        
        // For creating new Email PW Account
        newEmail = ""
        newPW = ""
        
        // Google Sign in Step 7. For automatic sign in.
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        
        //Facebook Login (Using FBSDKLoginButton)

        
        if (FBSDKAccessToken.current() != nil){
            print("FB: User logged in before")
        } else {
            let loginButton = FBSDKLoginButton()
            loginButton.center = self.view.center
            self.view.addSubview(loginButton)
            loginButton.delegate = self
        }
        
        //Facebook Login (Using LoginButton)
//        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
//        loginButton.center = view.center
//        
//        view.addSubview(loginButton)
        
    }
    
    @IBAction func SignOut(_ sender: UIButton) {
        modelSignOut()
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        newEmail = newEmailInput.text
        newPW = newPWInput.text
        
        modelSignUp(email: newEmail, PW: newPW)
    }

    
    @IBAction func GoogleSignIn(_ sender: Any) {

        // This function will sign in or sign up user
        GIDSignIn.sharedInstance().signIn()
    }
    
}
    

