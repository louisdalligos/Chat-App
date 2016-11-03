//
//  Message.swift
//  Chat App
//
//  Created by Louis on 29/10/2016.
//  Copyright © 2016 Wepro Co. Ltd. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromID: String?
    var text: String?
    var timestamp: NSNumber?
    var toID: String?
    var imageURL: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    func chatPartnerID() -> String? {
        return fromID == FIRAuth.auth()?.currentUser?.uid ? toID : fromID
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        fromID = dictionary["fromID"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toID = dictionary["toID"] as? String
        imageURL = dictionary["imageURL"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
    }
    
}
