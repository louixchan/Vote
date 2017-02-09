//
//  Utility.swift
//  Vote
//
//  Created by Chan Lo Yuet on 6/2/2017.
//  Copyright © 2017 Louis. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

let dbRef:FIRDatabaseReference = FIRDatabase.database().reference()

class Utility
{
    private static var dbRef:FIRDatabaseReference = FIRDatabase.database().reference()
    
    enum SnapshotError
    {
        case NilError
        case postError
    }
    
    static func checkNodeExist (node:FIRDatabaseReference, completion: @escaping (_ result:Bool?, _ error:SnapshotError?) -> Void)
    {
        node.observeSingleEvent(of: .value, with: { snapshot in
            
            completion(snapshot.exists(), nil)
        })
    }
    
    static func getTopic (topicId:String, completion: @escaping (_ topic:Topic?, _ error:SnapshotError?) -> Void)
    {
        dbRef.child("topics").child(topicId).observeSingleEvent(of: .value, with: { snapshot in
    
            if !snapshot.exists()
            {
                completion(nil, SnapshotError.NilError)
            }
            else
            {
                completion(Topic(snapshot: snapshot), nil)
            }
        })
    }
    
    static func getTopic (topicRef:FIRDatabaseReference, completion: @escaping (_ topic:Topic?, _ error:SnapshotError?) -> Void)
    {
        topicRef.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists()
            {
                completion(nil, SnapshotError.NilError)
            }
            else
            {
                completion(Topic(snapshot: snapshot), nil)
            }
        })
    }
    
    static func getTopic (topicSnapshot:FIRDataSnapshot, completion: @escaping (_ topic:Topic?, _ error:SnapshotError?) -> Void)
    {
        if !topicSnapshot.exists()
        {
            completion(nil, SnapshotError.NilError)
        }
        else
        {
            completion(Topic(snapshot: topicSnapshot), nil)
        }
    }
    
    /// Get all Topics in an array
    ///
    /// - Returns: Array of Topics, nil if no topic can be found
    static func getAllTopics (completion: @escaping (_ topics:[Topic]?, _ error:SnapshotError?) -> Void)
    {
        var topicArray:[Topic]?
        dbRef.child("topics").observeSingleEvent(of: .value, with: { snapshot in
            
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot
            {
                getTopic(topicSnapshot: rest.value as! FIRDataSnapshot)
                { (topic, error) in
                    
                    if error == nil
                    {
                        return
                    }
                    topicArray?.append(topic!)
                }
            }
            
            completion(topicArray, nil)
        })
        
    }
    
    /// Get Topics in an array with specific count
    ///
    /// - Parameter count: Number of Topics to get
    /// - Returns: Array of Topics, nil if no topics can be found
//    func getTopics (count:Int) -> [Topic?]?
//    {
//        let ref:FIRDatabaseReference = FIRDatabase.database().reference()
//        var result:[Topic?]? = nil
//        
//        return result
//    }
    
    
    
    // --
    // Vote Section
    // --
    
    static func getVote(voteId:String, completion: @escaping (_ vote:Vote?, _ error:SnapshotError?) -> Void)
    {
        dbRef.child("votes").child(voteId).observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists()
            {
                completion(nil, SnapshotError.NilError)
            }
            else
            {
                completion(Vote(snapshot: snapshot), nil)
            }
        })
    }
    
    static func getVote(voteRef:FIRDatabaseReference, completion: @escaping (_ vote:Vote?, _ error:SnapshotError?) -> Void)
    {
        voteRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists()
            {
                completion(nil, SnapshotError.NilError)
            }
            else
            {
                completion(Vote(snapshot: snapshot), nil)
            }
        })
    }
    
    static func getVote(voteSnapshot:FIRDataSnapshot, completion: @escaping (_ vote:Vote?, _ error:SnapshotError?) -> Void)
    {
        if !voteSnapshot.exists()
        {
            completion(nil, SnapshotError.NilError)
        }
        else
        {
            completion(Vote(snapshot: voteSnapshot), nil)
        }
    }
    
    static func postVote(vote:Vote, completion: @escaping (SnapshotError?) -> Void)
    {
//        var uuid:String!
//        
//        var voteRef:FIRDatabaseReference
//        
//        var unique:Bool = false
//        
//        while (!unique)
//        {
//            uuid = UUID().uuidString
//            voteRef = self.dbRef.child("vote").child(uuid)
//            
//            checkNodeExist(node: voteRef)
//            {
//                (exist, error) in
//                unique = exist!
//                if !exist!
//                {
//                    completion(nil)
//                }
//            }
//        }
//        
//        vote.setKey(newKey: uuid)
        
        var voteRef = self.dbRef.child("vote").child(vote.key)
        
        voteRef.setValue(vote.toAnyObject())
        
        // need to update vote count and vote history here
    }
    
    // --
    // User Section
    // --
    
    // --
    // Update Functions
    // --
    static func updateVoteCount(topicId:String, option:String, completion: @escaping (_ response:Bool, _ error:SnapshotError) -> Void)
    {
        
    }
    
    static func updateVoteHistory(userId:String, topicId:String, voteId:String, completion: @escaping (_ response:Bool, _ error:SnapshotError) -> Void)
    {
        
    }
}
