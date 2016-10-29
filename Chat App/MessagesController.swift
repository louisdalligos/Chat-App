//
//  MessagesController.swift
//  Chat App
//
//  Created by Louis on 25/10/2016.
//  Copyright © 2016 Wepro Co. Ltd. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    let cellID = "cellID"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "chat")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        observeMessages()
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            //print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                //print(message.text)
                self.messages.append(message)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
            }
            
            
            }, withCancel: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellID") // hack
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        
        if let toID = message.toID {
            let ref = FIRDatabase.database().reference().child("users").child(toID)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    cell.textLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageURL = dictionary["profileImageURL"] as? String {
                        cell.profileImageView.loadImagesUsingCacheWithURLString(urlString: profileImageURL)
                    }
                }
                //print(snapshot)
            })
        }
        
        
//        cell.textLabel?.text = message.toID
        cell.detailTextLabel?.text = message.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
        
    }
    
    
    func checkIfUserIsLoggedIn() {
        // user is not logged in
        if FIRAuth.auth()?.currentUser?.uid == nil {
            performSelector(onMainThread: #selector(handleLogout), with: nil, waitUntilDone: true)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
        
    }
    
    func fetchUserAndSetupNavBarTitle() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            // if for some reason the uid = nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //self.navigationItem.title = dictionary["name"] as? String
                
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user: user)
            }
            
            
            }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user: User) {
        
        //self.navigationItem.title = user.name
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        //titleView.backgroundColor = UIColor.red
        
        
        let nameLabel = UILabel()
        titleView.addSubview(nameLabel) // add the view
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        
        
        self.navigationItem.titleView = titleView
        
//        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    
    
    func showChatControllerForUser(user: User) {
        //print(123)
        
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }
    
    

}

