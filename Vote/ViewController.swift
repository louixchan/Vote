//
//  ViewController.swift
//  Vote
//
//  Created by Chan Lo Yuet on 25/1/2017.
//  Copyright © 2017 Louis. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    
    var dbRef:FIRDatabaseReference!
    var topicRef:FIRDatabaseReference!
    var voteRef:FIRDatabaseReference!
    var voteHistoryRef:FIRDatabaseReference!
    var topicHistoryRef:FIRDatabaseReference!
    var voteCountRef:FIRDatabaseReference!
    var storageRef:FIRStorageReference!
    
    var fileURL:URL!
    
    var user:String!
    
    var topic:String!
    
    let date = NSDate()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
        topicRef = dbRef.child("topics")
        voteRef = dbRef.child("vote")
        voteHistoryRef = dbRef.child("voteHistory")
        topicHistoryRef = dbRef.child("topicHistory")
        voteCountRef = dbRef.child("voteCount")
        storageRef = FIRStorage.storage().reference()
        
        picker.delegate = self
        
        topic = "9090AC8C-59E0-473F-8F0E-8A7DDFFF4C89"
        //"0"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Delegates
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        TopicImage.contentMode = .scaleAspectFit
        TopicImage.image = chosenImage
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //--
    // Action Functions
    //--
    
    @IBAction func LoadTopic(_ sender: UIButton) {
        
        self.topicRef.child(topic).observeSingleEvent(of: .value, with: { snapshot in
            
            var loadTopic:Topic
            
            if !snapshot.exists()
            {
                return
            }
            
            loadTopic = Topic(snapshot: snapshot)
            
            let imageRef = FIRStorage.storage().reference(withPath: "/" + loadTopic.imageURL)
            imageRef.data(withMaxSize: 1024 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print(error)
                }
                else
                {
                    self.TopicImage.image = UIImage(data: data!)
                }
            }
        })
    }
    
    @IBAction func ChooseOption1(_ sender: UIButton) {
        
        user = FIRAuth.auth()?.currentUser?.uid
        let vote = Vote(topic: self.topic, option: 0, description:Option1.currentTitle!, addedByUser: user)
        
        var uuid:String!
        uuid = UUID().uuidString
        
        var voteRef = self.dbRef.child("vote").child(uuid)
        
        while (checkNodeExist(node: voteRef))
        {
            uuid = UUID().uuidString
            voteRef = self.dbRef.child("vote").child(uuid)
        }
        
        voteRef.setValue(vote.toAnyObject())
        
        updateVoteCount(topic: self.topic, option: "0")
        
        updateVoteHistory(user:user, voteId:uuid, topic:topic)
    }

    @IBAction func ChooseOption2(_ sender: UIButton) {
        
        user = FIRAuth.auth()?.currentUser?.uid
        let vote = Vote(topic: self.topic, option: 1, description:Option2.currentTitle!, addedByUser: user)
        
        var uuid:String!
        uuid = UUID().uuidString
        
        var voteRef = self.dbRef.child("vote").child(uuid)
        
        while (checkNodeExist(node: voteRef))
        {
            uuid = UUID().uuidString
            voteRef = self.dbRef.child("vote").child(uuid)
        }
        
        voteRef.setValue(vote.toAnyObject())
        
        updateVoteCount(topic: self.topic, option: "1")
        
        updateVoteHistory(user:user, voteId:uuid, topic:topic)
    }
    
    @IBAction func ChooseOtherOption(_ sender: UIButton) {
        
        if (OtherOption.text == nil) || (OtherOption.text == "")
        {
            
        }
        else
        {
            user = FIRAuth.auth()?.currentUser?.uid
            let vote = Vote(topic: self.topic, option: -1, addedByUser: user)
            
            var uuid:String!
            uuid = UUID().uuidString
            
            var voteRef = self.dbRef.child("vote").child(uuid)
            
            while (checkNodeExist(node: voteRef))
            {
                uuid = UUID().uuidString
                voteRef = self.dbRef.child("vote").child(uuid)
            }
            
            voteRef.setValue(vote.toAnyObject())
            
            updateVoteCount(topic: self.topic, option: "-1")
            
            updateVoteHistory(user:user, voteId:uuid, topic:topic)
        }
    }
    
    @IBAction func PostNewTopic(_ sender: UIButton){
        for textField in self.NewTopic
        {
            if (textField.text == nil) || (textField.text == "")
            {
                return
            }
        }
        
        var count = 0
        
        for textField in self.NewTopicOptions
        {
            if (textField.text != nil) && (textField.text != "")
            {
                count += 1
            }
        }
        
        if count == 0
        {
            return
        }
        
        user = FIRAuth.auth()?.currentUser?.uid
        
        var i = 0
        var newOptions: [String: String] = [:]
        
        for textField in self.NewTopicOptions
        {
            if (textField.text == nil) || (textField.text == "")
            {
                
            }
            else
            {
                newOptions[String(i)] = textField.text
                i += 1
            }
        }
        
        newOptions["-1"] = "Others"
        
        var uuid:String!
        uuid = UUID().uuidString
        
        var imagePath = ""
        if TopicImage.image != nil
        {
            let uuid = UUID().uuidString
            let imageRef = storageRef.child("images").child(uuid + ".png")
            imagePath = "images/" + uuid + ".png"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/png"
            let uploadTask = imageRef.put(UIImagePNGRepresentation(TopicImage.image!)!, metadata: metadata)
        }
        
        uuid = UUID().uuidString
        
        let topic = Topic(title: NewTopicTitle.text!, options: newOptions, description: NewTopicDescription.text!, addedByUser: user, imageURL: imagePath)
        
        var topicRef = self.dbRef.child("topics").child(uuid)
        
        while (checkNodeExist(node: topicRef))
        {
            uuid = UUID().uuidString
            topicRef = self.dbRef.child("topics").child(uuid)
        }
        
        topicRef.setValue(topic.toAnyObject())
        
        initOptionCount(topicId: uuid, options: Array(newOptions.keys))
        
        updatePostHistory(user: user, topicId: uuid, approved: true)
    }
    
    @IBAction func ChooseImage(_ sender: UIButton) {
        picker.allowsEditing = false //2
        picker.sourceType = .photoLibrary //3
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)//4
        picker.popoverPresentationController?.sourceView = sender
    }
    
    //--
    // Outlet Variables
    //--
    
    @IBOutlet var NewTopic: [UITextField]!
    
    @IBOutlet var NewTopicOptions: [UITextField]!
    
    @IBOutlet weak var NewTopicTitle: UITextField!
    @IBOutlet weak var NewTopicDescription: UITextField!
    @IBOutlet weak var Option1: UIButton!
    @IBOutlet weak var Option2: UIButton!
    @IBOutlet weak var OtherOption: UITextField!
    @IBOutlet weak var TopicImage: UIImageView!
    @IBOutlet var DownloadURL: UITextField!
    
    //--
    // Utility Functions
    //--
    
    func updateVoteCount(topic:String, option:String)
    {
        self.voteCountRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists()
            {
                self.voteCountRef.setValue(1)
            }
            self.voteCountRef.setValue(snapshot.value as! Int + 1)
        })
    }
    
    func updateVoteHistory(user:String, voteId:String, topic:String)
    {
        voteHistoryRef.child(user).child(voteId).setValue(topic)
    }
    
    func updatePostHistory(user:String, topicId:String, approved:Bool)
    {
        topicHistoryRef.child(user).child(topicId).setValue(approved)
    }
    
    func initOptionCount(topicId:String, options:[String])
    {
        var result = [String: Int]()
        for key in options
        {
            result[key] = 0
        }
        voteCountRef.child(topicId).setValue(result)
    }
    
    func checkNodeExist(node:FIRDatabaseReference) -> Bool
    {
        var result = false
        node.observeSingleEvent(of: .value, with: { snapshot in
            
            result = snapshot.exists()
        })
        
        return result
    }

    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

