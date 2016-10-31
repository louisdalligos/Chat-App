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
    
    func chatPartnerID() -> String? {
        return fromID == FIRAuth.auth()?.currentUser?.uid ? toID : fromID
    }
    
}
