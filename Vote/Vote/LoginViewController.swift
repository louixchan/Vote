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

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    var newEmail:String!
    var newPW:String!
    
    @IBOutlet weak var newEmailInput: UITextField!
    @IBOutlet weak var newPWInput: UITextField!
    @IBOutlet weak var GoogleSignInButton: GIDSignInButton!

    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        newEmail = ""
        newPW = ""
        
        // Google Sign in Step 7.
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func SignOut(_ sender: UIButton) {
        modelSignOut()
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        newEmail = newEmailInput.text
        newPW = newPWInput.text
        
        modelSignUp(email: newEmail, PW: newPW)
    }
    
    
}
