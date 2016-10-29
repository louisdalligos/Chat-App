//
//  UserCell.swift
//  Chat App
//
//  Created by Louis on 29/10/2016.
//  Copyright © 2016 Wepro Co. Ltd. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            if let toID = message?.toID {
                let ref = FIRDatabase.database().reference().child("users").child(toID)
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        self.textLabel?.text = dictionary["name"] as? String
                        
                        if let profileImageURL = dictionary["profileImageURL"] as? String {
                            self.profileImageView.loadImagesUsingCacheWithURLString(urlString: profileImageURL)
                        }
                    }
                    //print(snapshot)
                })
            }

            detailTextLabel?.text = message?.text
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 66, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 66, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default-profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 26
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
