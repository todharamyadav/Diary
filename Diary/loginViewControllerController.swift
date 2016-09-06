//
//  loginViewControllerController.swift
//  Diary
//
//  Created by Dharamvir on 8/26/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Actions
    
    func handleLoginSegmentControl(){
        let buttonTitle = loginSegmentControl.titleForSegmentAtIndex(loginSegmentControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(buttonTitle, forState: .Normal)
        
        heighConstraintLoginController?.constant = loginSegmentControl.selectedSegmentIndex == 0 ? 98 : 146
        heightConstriantName?.constant = loginSegmentControl.selectedSegmentIndex == 0 ? 0 : 48
        
        
        profileImageView.hidden = loginSegmentControl.selectedSegmentIndex == 0 ? true : false
        
    }
    
    func handleLoginRegister(){
        if loginSegmentControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
        
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, password = passwordTextField.text else{
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error != nil{
                print(error)
                print("Please check your email address or password")
                return
            }
            
            //successfully logged in
            
            
            self.settingController?.setUpNavigationItemTitle()
            self.albumController?.setUpNavigationItemTitle()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func handleRegister(){
        guard let email = emailTextField.text, password = passwordTextField.text, name = nameTextField.text else{
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil{
                print(error)
                return
            }
            
            guard let uid = user?.uid else{
                return
            }
            
            //successfully authenticated user
            let imageName = NSUUID().UUIDString
            let storageRef = FIRStorage.storage().reference().child("Profile_Images").child("\(imageName).png")
            
            if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error)
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                        
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        
                        self.registerUserIntoDatabase(uid, values: values)
                    }
                    
                })
            }
            
        })
    }
    
    private func registerUserIntoDatabase(uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err)
                return
            }
            
            let user = User()
            user.setValuesForKeysWithDictionary(values)
            self.settingController?.setUpNavBarWithUser(user)
            self.albumController?.setUpNavBarWithUser(user)
            self.dismissViewControllerAnimated(true, completion: nil)
            print("saved user successfully")
        })
    }
    
    func uploadProfilePhoto(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Mark: UIImakePickerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImageFromPicker: UIImage?
        if let editedProfileImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedProfileImage
        } else if let originalProfileImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalProfileImage
        }
        
        if let selectedimage = selectedImageFromPicker{
            profileImageView.image = selectedimage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}








