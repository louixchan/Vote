//
//  Auth.swift
//  Vote
//
//  Created by Ching Kim Fu Cliff on 2/4/17.
//  Copyright © 2017 Louis. All rights reserved.
//

import Foundation
import Firebase



    
// Signout to the app, will think of a better naming convention later on

func modelSignOut() {
    let firebaseAuth = FIRAuth.auth()
    do {
        try firebaseAuth?.signOut()
    } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
    }
}

func modelSignUp(email:String, PW:String) {
    FIRAuth.auth()?.createUser(withEmail: email, password: PW, completion: {(user,error) in
        if error != nil {
            print("Error signing up: %@", error!)
        } else {
            // Sign up sucessful
            var dbRef = FIRDatabase.database().reference().child("users").child(user!.uid)
            dbRef.child("email").setValue(email)
            
            
        }
    })
}




