//
//  NewMessageController.swift
//  Chat App
//
//  Created by Louis on 27/10/2016.
//  Copyright © 2016 Wepro Co. Ltd. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellID = "cellID"
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        fetchUser()
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User()
                user.id = snapshot.key
                
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                self.tableView.reloadData()
                
                //print(user.name, user.email)
            }
            
            
            //print("User found")
            //print(snapshot)
            
            }, withCancel: nil)
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
//        cell.imageView?.image = UIImage(named: "al")
//        cell.imageView?.contentMode = .scaleAspectFill
        
        if let profileImageURL = user.profileImageURL {
            
            cell.profileImageView.loadImagesUsingCacheWithURLString(urlString: profileImageURL)
            
//            let url = URL(string: profileImageURL)
//            
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                
//                if error != nil {
//                    print("LOUIS\(error)")
//                    return
//                }
//                
//                
//                DispatchQueue.main.async(execute: {
//                    print("LOUIS: \(url)")
//                    cell.profileImageView.image = UIImage(data: data!)
//                })
//                
//            }).resume()
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { 
            print("Dismiss completed")
            
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user: user)
        }
    }

}
