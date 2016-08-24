//
//  SettingViewController.swift
//  Diary
//
//  Created by Dharamvir on 8/23/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let userDefault = NSUserDefaults.standardUserDefaults()
    var profileImage: UIImage?
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Mark")
        image.contentMode = .ScaleAspectFit
        //image.backgroundColor = UIColor.redColor()
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Dharamvir Kumar Yadav"
        label.font = UIFont.systemFontOfSize(24)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .Center
        //label.backgroundColor = UIColor.blueColor()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Name", style: .Plain, target: self, action: #selector(editName))
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        
        view.addConstraintsWithFormat("H:|-60-[v0]-60-|", views: profileImageView)
        view.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: nameLabel)
        
        view.addConstraintsWithFormat("V:|-80-[v0(200)]-8-[v1]", views: profileImageView, nameLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImagePressed))
        tap.delegate = self
        profileImageView.addGestureRecognizer(tap)
        
        if let name = userDefault.objectForKey("NAME"){
            nameLabel.text = name as? String
        }
        
        if let profileImg = userDefault.objectForKey("PROFILEIMAGE"){
            profileImageView.image = profileImg as? UIImage
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editName() {
        let alert = UIAlertController(title: "Name", message: "Enter Your Name", preferredStyle: .Alert)
        
        let saveButton = UIAlertAction(title: "Save", style: .Default) { (action) in
            let textField = alert.textFields![0] as UITextField
            
            self.nameLabel.text = textField.text
            self.userDefault.setObject(textField.text, forKey: "NAME")
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        alert.addTextFieldWithConfigurationHandler(nil)
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func profileImagePressed(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Mark: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        profileImageView.image = profileImage
        userDefault.setObject(profileImage, forKey: "PROFILEIMAGE")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }


}
