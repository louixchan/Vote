//
//  Vote.swift
//  Vote
//
//  Created by Chan Lo Yuet on 28/1/2017.
//  Copyright © 2017 Louis. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Vote {
    
    let key:String!
    let topic:String!
    let option:Int!
    let description:String!
    let addedByUser:String!
    let itemRef:FIRDatabaseReference?
    let year:Int!
    let month:Int!
    let day:Int!
    let hour:Int!
    let minute:Int!
    let second:Int!
    let dayOfWeek:Int!
    let timeZone:String!
    let isDaylightSaving:Bool!
    let dayLightSavingOffset:TimeInterval!
    
    init (topic:String, option:Int = -1, description:String = "", addedByUser:String, key:String = "")
    {
        self.key = key
        self.topic = topic
        self.addedByUser = addedByUser
        self.itemRef = nil
        self.option = option
        self.description = description
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        self.year = Int(formatter.string(from: Date()))
        formatter.dateFormat = "MM"
        self.month = Int(formatter.string(from: Date()))
        formatter.dateFormat = "dd"
        self.day = Int(formatter.string(from: Date()))
        formatter.dateFormat = "hh"
        self.hour = Int(formatter.string(from: Date()))
        formatter.dateFormat = "mm"
        self.minute = Int(formatter.string(from: Date()))
        formatter.dateFormat = "ss"
        self.second = Int(formatter.string(from: Date()))
        let calendar = Calendar(identifier: .gregorian)
        self.dayOfWeek = calendar.component(.weekday, from: Date())
        self.timeZone = NSTimeZone.local.abbreviation(for: Date())
        self.isDaylightSaving = NSTimeZone.local.isDaylightSavingTime(for: Date())
        self.dayLightSavingOffset = NSTimeZone.local.daylightSavingTimeOffset(for: Date())
        
    }
    
    init (snapshot:FIRDataSnapshot)
    {
        key = snapshot.key
        itemRef = snapshot.ref
        
        topic = (snapshot.value as? NSDictionary)?["topic"] as? String ?? ""
        
        addedByUser = (snapshot.value as? NSDictionary)?["user"] as? String ?? ""
        
        option = (snapshot.value as? NSDictionary)?["option"] as? Int ?? -1
        
        description = (snapshot.value as? NSDictionary)?["description"] as? String ?? ""
        
        year = (snapshot.value as? NSDictionary)?["year"] as? Int ?? -1
        
        month = (snapshot.value as? NSDictionary)?["month"] as? Int ?? -1
        
        day = (snapshot.value as? NSDictionary)?["day"] as? Int ?? -1
        
        hour = (snapshot.value as? NSDictionary)?["hour"] as? Int ?? -1
        
        minute = (snapshot.value as? NSDictionary)?["minute"] as? Int ?? -1
        
        second = (snapshot.value as? NSDictionary)?["second"] as? Int ?? -1
        
        dayOfWeek = (snapshot.value as? NSDictionary)?["dayOfWeek"] as? Int ?? -1
        
        timeZone = (snapshot.value as? NSDictionary)?["timeZone"] as? String ?? ""
        
        isDaylightSaving = (snapshot.value as? NSDictionary)?["isDaylightSaving"] as? Bool ?? false
        
        dayLightSavingOffset = (snapshot.value as? NSDictionary)?["dayLightSavingOffset"] as? Double ?? 0
    }
    
    func toAnyObject() -> AnyObject {
        return ["topic":topic, "addedByUser":addedByUser, "option":option, "description":description, "year":year, "month":month, "day":day, "hour":hour, "minute":minute, "second":second, "dayOfWeek":dayOfWeek, "timeZone":timeZone, "isDaylightSaving":isDaylightSaving, "daylightSavingOffset":dayLightSavingOffset ] as AnyObject
    }
}
