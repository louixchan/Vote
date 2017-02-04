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


class LoginViewController: UIViewController {
    
    var newEmail:String!
    var newPW:String!
    
    @IBOutlet weak var newEmailInput: UITextField!
    @IBOutlet weak var newPWInput: UITextField!
    
    override func viewDidLoad(){
        newEmail = ""
        newPW = ""
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
