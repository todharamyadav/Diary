//
//  SettingViewController.swift
//  Diary
//
//  Created by Dharamvir on 8/23/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var profileImage: UIImage?
    var albumController: AlbumCollectionViewController?
    let reachability = Reachability.reachabilityForInternetConnection()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.image = UIImage(named: "Profile")
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadProfilePhoto)))
        imageView.userInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(24)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .Center
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editName)))
        label.userInteractionEnabled = true
        return label
    }()
    
    lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", forState: .Normal)
        button.backgroundColor = UIColor.redColor()
        button.addTarget(self, action: #selector(handleLogOut), forControlEvents: .TouchUpInside)
        return button
    }()
    
    func handleLogOut(){
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutErr{
            print(logoutErr)
        }
        
        let loginController = LoginViewController()
        loginController.settingController = self
        presentViewController(loginController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        navigationItem.title = "Settings"
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(logOutButton)
        
        view.addConstraintsWithFormat("H:[v0(200)]", views: profileImageView)
        NSLayoutConstraint(item: profileImageView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0).active = true
        view.addConstraintsWithFormat("H:[v0]", views: nameLabel)
        NSLayoutConstraint(item: nameLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0).active = true
        view.addConstraintsWithFormat("H:|-15-[v0]-15-|", views: logOutButton)
        
        view.addConstraintsWithFormat("V:|-150-[v0(200)]-8-[v1(30)]", views: profileImageView, nameLabel)
        view.addConstraintsWithFormat("V:[v0(40)]-80-|", views: logOutButton)
        
        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            performSelector(#selector(handleLogOut), withObject: nil, afterDelay: 0)
        } else{
            setUpNavigationItemTitle()
            
        }
    }
    
    func setUpNavigationItemTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User()
                user.setValuesForKeysWithDictionary(dictionary)
                self.setUpNavBarWithUser(user)
            }
            
            
            }, withCancelBlock: nil)
    }
    
    func setUpNameLabel(name: String){
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "Edit_Button")
        attachment.bounds = CGRectMake(5, -5, 30, 30)
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: name)
        myString.appendAttributedString(attachmentString)
        nameLabel.attributedText = myString
    }
    
    func setUpNavBarWithUser(user: User) {
        
        setUpNameLabel(user.name!)
        
        if let profileImageUrl = user.profileImageUrl{
            profileImageView.loadImagWithCacheAndUrlString(profileImageUrl)
        }
        
        albumController?.setUpNavigationItemTitle()
    }

    
    func editName() {
        
        let alertController = UIAlertController(title: "Album Name", message: "New Album Name", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action) in
            if let textField = alertController.textFields?.first {
                if (textField.text!.isEmpty){
                    self.alertError("Error", message: "Name field can't be empty")
                }else if (self.reachability.currentReachabilityStatus().rawValue == 0){
                    self.alertError("Error", message: "Could not be saved because of internet error or something else")
                }
                else{
                    self.setUpNameLabel(textField.text!)
                    
                    guard let uid = FIRAuth.auth()?.currentUser?.uid else{
                        return
                    }
                    let ref = FIRDatabase.database().reference().child("users").child(uid)
                    let values = ["name": textField.text!]
                    ref.updateChildValues(values)
                }

            }
            
        }))
        
        alertController.addTextFieldWithConfigurationHandler({ (textfield) in
            textfield.placeholder = "Album Name"
        })
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func uploadProfilePhoto(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let alertController = UIAlertController(title: "Select Source for Image", message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Gallery", style: .Default) { (action) in
            imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
            })
        alertController.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (action) in
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
            
        }))
        
        presentViewController(alertController, animated: true, completion: nil)

    }
    
    //Mark: UIImakePickerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImageFromPicker: UIImage?
        if let editedProfileImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedProfileImage
        } else if let originalProfileImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalProfileImage
        }
        dismissViewControllerAnimated(true, completion: nil)
        
        if (self.reachability.currentReachabilityStatus().rawValue == 0){
            self.alertError("Error", message: "Could not be saved because of internet error or something else")
        }else{
            if let selectedimage = selectedImageFromPicker{
                profileImageView.image = selectedimage
                
                guard let uid = FIRAuth.auth()?.currentUser?.uid else{
                    return
                }
                let ref = FIRDatabase.database().reference().child("users").child(uid)
                ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    print(snapshot)
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        let profileOldImageUrl = dictionary["profileImageUrl"] as? String
                        print(profileOldImageUrl)
                        let storageRef = FIRStorage.storage().referenceForURL(profileOldImageUrl!)
                        storageRef.deleteWithCompletion({ (error) in
                            if error != nil{
                                print("Cannot be deleted")
                                return
                            }
                            
                            let imageName = NSUUID().UUIDString
                            let storageRef = FIRStorage.storage().reference().child("Profile_Images").child("\(imageName).png")
                            
                            if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1){
                                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                    if error != nil{
                                        print(error)
                                        return
                                    }
                                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                                        
                                        let values = ["profileImageUrl": profileImageUrl]
                                        
                                        ref.updateChildValues(values)
                                    }
                                    
                                })
                            }
                            
                        })
                        
                    }
                    }, withCancelBlock: nil)
            }
        }

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
