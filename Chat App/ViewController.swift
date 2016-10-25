//
//  ViewController.swift
//  Chat App
//
//  Created by Louis on 25/10/2016.
//  Copyright © 2016 Wepro Co. Ltd. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let ref = FIRDatabase.database().reference(fromURL: "https://chat-app-65aed.firebaseio.com/")
        //ref.updateChildValues(["someValue": 1123232])
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    func handleLogout() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    

}

