//
//  LoginController+handlers.swift
//  Chat App
//
//  Created by Louis on 27/10/2016.
//  Copyright © 2016 Wepro Co. Ltd. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleRegistration() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print("LOUIS: \(error)")
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "profileImageURL": profileImageURL]
                        
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    }

                    //print(metadata)
                })
            }
        })
    }
    
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        let ref = FIRDatabase.database().reference(fromURL: "https://chat-app-65aed.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        // let values = ["name": name, "email": email, "profileImageURL": metadata.downloadURL()]
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print("LOUIS: \(err)")
                return
            }
            
            print("Saved user successfully in Firebase DB")
            
            // self.messagesController?.fetchUserAndSetupNavBarTitle()
            self.messagesController?.navigationItem.title = values["name"] as? String
            
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    
    func handleSelectProfileImage() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            //print((editedImage as AnyObject).size)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            //print((originalImage as AnyObject).size)
            selectedImageFromPicker = originalImage
        }
        
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        //print(info)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled picker")
        dismiss(animated: true, completion: nil)
    }
    
}
