//
//  Topic.swift
//  Vote
//
//  Created by Chan Lo Yuet on 31/1/2017.
//  Copyright © 2017 Louis. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Topic{
    
    let key:String!
    let title:String!
    let description:String!
    let imageURL:String!
    let addedByUser:String!
    let postDate:String!
    let postTime:String!
    let options:[String: String]!
    let itemRef:FIRDatabaseReference?
    
    init (title:String, options:[String: String], description:String = "", addedByUser:String, key:String = "", imageURL:String = "")
    {
        self.key = key
        self.title = title
        self.addedByUser = addedByUser
        self.itemRef = nil
        self.options = options
        self.description = description
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.postDate = formatter.string(from: Date())
        formatter.dateFormat = "hh:mm:ss"
        self.postTime = formatter.string(from: Date())
        self.imageURL = imageURL
    }
    
    init (snapshot:FIRDataSnapshot)
    {
        key = snapshot.key
        itemRef = snapshot.ref
        
        title = (snapshot.value as? NSDictionary)?["title"] as? String ?? ""
        
        addedByUser = (snapshot.value as? NSDictionary)?["addedByUser"] as? String ?? ""
        
        options = nil
        
        description = (snapshot.value as? NSDictionary)?["description"] as? String ?? ""
        
        postDate = (snapshot.value as? NSDictionary)?["postDate"] as? String ?? ""
        
        postTime = (snapshot.value as? NSDictionary)?["postDate"] as? String ?? ""
        
        imageURL = (snapshot.value as? NSDictionary)?["imageURL"] as? String ?? ""
    }
    
    func toAnyObject() -> AnyObject {
        return ["title":title, "addedByUser":addedByUser, "description":description, "options":options, "postDate":postDate, "postTime":postTime, "approved":true, "viewCount":0, "voteCount":0, "imageURL":imageURL] as AnyObject
    }
}
