//
//  User.swift
//  Vote
//
//  Created by Chan Lo Yuet on 28/1/2017.
//  Copyright © 2017 Louis. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let email: String
    
    init(uid: String, email: String)
    {
        self.uid = uid
        self.email = email
    }
}
