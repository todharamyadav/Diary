//
//  AddPostViewController.swift
//  Diary
//
//  Created by Dharamvir on 8/22/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
import CoreLocation

class AddPostViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate {
    
    var album: Album?
    var clLocationManager = CLLocationManager()
    var address: String? = ""
    var placeholder = "Write something"
    
    let postTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFontOfSize(16)
        textView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        return textView
    }()
    
    let imageContainerView: UIView = {
        let imageView = UIView()
        imageView.backgroundColor = UIColor.whiteColor()
        return imageView
    }()
    
    let cameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Camera")
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    let cameraLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(16)
        label.text = "Add Photo"
        return label
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    

    var bottomConstraintImageContainer: NSLayoutConstraint?
    var bottomConstraintPostTextView: NSLayoutConstraint?
    
    override func viewWillAppear(animated: Bool) {
        if postTextView.text == ""{
            postTextView.text = placeholder
            postTextView.textColor = UIColor.lightGrayColor()
        }else{
            postTextView.textColor = UIColor.blackColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Story"
        view.backgroundColor = UIColor(red: 26/255, green: 175/255, blue: 226/255, alpha: 1)
        self.automaticallyAdjustsScrollViewInsets = false
        postTextView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(saveData))
        
        view.addSubview(postTextView)
        view.addSubview(photoImageView)
        view.addSubview(imageContainerView)
        
        view.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: postTextView)
        view.addConstraintsWithFormat("V:|-70-[v0(260)]-2-[v1]-50-|", views: postTextView, photoImageView)

        
        view.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: photoImageView)
        
        view.addConstraintsWithFormat("H:|[v0]|", views: imageContainerView)
        
        view.addConstraintsWithFormat("V:[v0(50)]", views: imageContainerView)
        bottomConstraintImageContainer = NSLayoutConstraint(item: imageContainerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraintImageContainer!)
        
        setUpImageContainerView()
        
        clLocationManager.delegate=self
        clLocationManager.desiredAccuracy=kCLLocationAccuracyBest
        clLocationManager.requestWhenInUseAuthorization()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardNotification), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardNotification), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func imageContainerPressed(){
        
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        postTextView.resignFirstResponder()
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.textColor = UIColor.blackColor()
        if (textView.text == placeholder){
            textView.text = ""
        }
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if(textView.text == "") {
            textView.text = placeholder
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func setUpImageContainerView(){
        let borderView = UIView()
        borderView.backgroundColor = UIColor.darkGrayColor()
        
        imageContainerView.addSubview(cameraImageView)
        imageContainerView.addSubview(cameraLabel)
        imageContainerView.addSubview(borderView)
        
        imageContainerView.addConstraintsWithFormat("H:|-8-[v0(50)]-8-[v1]|", views: cameraImageView, cameraLabel)
        imageContainerView.addConstraintsWithFormat("H:|[v0]|", views: borderView)
        
        imageContainerView.addConstraintsWithFormat("V:|[v0]|", views: cameraImageView)
        imageContainerView.addConstraintsWithFormat("V:|[v0]|", views: cameraLabel)
        imageContainerView.addConstraintsWithFormat("V:|[v0(0.5)]", views: borderView)
        
        imageContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageContainerPressed)))
        imageContainerView.userInteractionEnabled = true
    }
    
    func handleKeyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo{
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
            
            let isKeyboardShowing = notification.name == UIKeyboardWillShowNotification
            
            bottomConstraintImageContainer?.constant = isKeyboardShowing ? -keyboardFrame!.height:0
            
            UIView.animateWithDuration(0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
        
    }
    
    //Mark: UIImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        var selectedImage: UIImage?
        if let editedProfileImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImage = editedProfileImage
        } else if let originalProfileImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = originalProfileImage
        }
        
        if let selectedimage = selectedImage{
            photoImageView.image = selectedimage
        }

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print(error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        clLocationManager.stopUpdatingLocation()
        //print(locations)
        
        let myCurrentLocation = locations[0]
        
        //geocoder
        CLGeocoder().reverseGeocodeLocation(myCurrentLocation) { (myPlacements, myError) in
            if (myError != nil){
                
            }
            if let myPlacement = myPlacements?[0]{
                self.address = "\(myPlacement.locality!), \(myPlacement.administrativeArea!)"
                
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        switch status {
        case .Denied:
            clLocationManager.stopUpdatingLocation()
            break
        case .AuthorizedWhenInUse:
            clLocationManager.startUpdatingLocation()
            break
        default:
            break
        }
    }
}








