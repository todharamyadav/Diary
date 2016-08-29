////
////  AddPostViewController.swift
////  Diary
////
////  Created by Dharamvir on 8/22/16.
////  Copyright © 2016 Dharamvir. All rights reserved.
////
//
//import UIKit
//import CoreData
//import CoreLocation
//
//class AddPostViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
//    
//    var album: Album?
//    var clLocationManager = CLLocationManager()
//    var address: String?
//    
//    
//    let postTextView: UITextView = {
//        let textView = UITextView()
//        textView.font = UIFont.systemFontOfSize(16)
//        textView.text = "What are you doing"
//        return textView
//    }()
//    
//    let imageContainerView: UIView = {
//        let imageView = UIView()
//        imageView.backgroundColor = UIColor.whiteColor()
//        return imageView
//    }()
//    
//    let cameraImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "Camera")
//        imageView.contentMode = .ScaleAspectFit
//        return imageView
//    }()
//    
//    let cameraLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFontOfSize(16)
//        label.text = "Add Photo"
//        return label
//    }()
//    
//    let photoImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .ScaleAspectFill
//        imageView.layer.masksToBounds = true
//        return imageView
//    }()
//    
//
//    var bottomConstraintImageContainer: NSLayoutConstraint?
//    var bottomConstraintPostTextView: NSLayoutConstraint?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.whiteColor()
//        
//        let bottomBorderView = UIView()
//        bottomBorderView.backgroundColor = UIColor(white: 0.95, alpha: 1)
//        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(saveData))
//        
//        view.addSubview(postTextView)
//        view.addSubview(photoImageView)
//        view.addSubview(imageContainerView)
//        view.addSubview(bottomBorderView)
//        
//        view.addConstraintsWithFormat("H:|[v0]|", views: postTextView)
//        view.addConstraintsWithFormat("V:|[v0(290)][v1(0.5)][v2]-50-|", views: postTextView, bottomBorderView, photoImageView)
////        bottomConstraintPostTextView = NSLayoutConstraint(item: postTextView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -350)
////        view.addConstraint(bottomConstraintPostTextView!)
//        
//        view.addConstraintsWithFormat("H:|[v0]|", views: photoImageView)
////        view.addConstraintsWithFormat("V:|[v0]", views: photoImageView)
////        bottomConstraintPostTextView = NSLayoutConstraint(item: photoImageView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -50)
////        view.addConstraint(bottomConstraintPostTextView!)
//        
//        view.addConstraintsWithFormat("H:|[v0]|", views: imageContainerView)
//        view.addConstraintsWithFormat("H:|[v0]|", views: bottomBorderView)
//        
//        view.addConstraintsWithFormat("V:[v0(50)]", views: imageContainerView)
//        bottomConstraintImageContainer = NSLayoutConstraint(item: imageContainerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
//        view.addConstraint(bottomConstraintImageContainer!)
//        
//        setUpImageContainerView()
//        
//        clLocationManager.delegate=self
//        clLocationManager.desiredAccuracy=kCLLocationAccuracyBest
//        clLocationManager.requestWhenInUseAuthorization()
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(imageContainerPressed))
//        tap.delegate = self
//        imageContainerView.addGestureRecognizer(tap)
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardNotification), name: UIKeyboardWillShowNotification, object: nil)
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardNotification), name: UIKeyboardWillHideNotification, object: nil)
//    }
//    
//    func imageContainerPressed(){
//        let uiImagePicker = UIImagePickerController()
//        uiImagePicker.sourceType = .PhotoLibrary
//        uiImagePicker.delegate = self
//        presentViewController(uiImagePicker, animated: true, completion: nil)
//    }
//    
//    func setUpImageContainerView(){
//        let borderView = UIView()
//        borderView.backgroundColor = UIColor.darkGrayColor()
//        
//        imageContainerView.addSubview(cameraImageView)
//        imageContainerView.addSubview(cameraLabel)
//        imageContainerView.addSubview(borderView)
//        
//        imageContainerView.addConstraintsWithFormat("H:|-8-[v0(50)]-8-[v1]|", views: cameraImageView, cameraLabel)
//        imageContainerView.addConstraintsWithFormat("H:|[v0]|", views: borderView)
//        
//        imageContainerView.addConstraintsWithFormat("V:|[v0]|", views: cameraImageView)
//        imageContainerView.addConstraintsWithFormat("V:|[v0]|", views: cameraLabel)
//        imageContainerView.addConstraintsWithFormat("V:|[v0(0.5)]", views: borderView)
//
//        
//        
//    }
//    
//    func handleKeyboardNotification(notification: NSNotification){
//        if let userInfo = notification.userInfo{
//            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
//            
//            let isKeyboardShowing = notification.name == UIKeyboardWillShowNotification
//            
//            bottomConstraintImageContainer?.constant = isKeyboardShowing ? -keyboardFrame!.height:0
//            //bottomConstraintPostTextView?.constant = isKeyboardShowing ? -keyboardFrame!.height - 50:-50
//            
//            UIView.animateWithDuration(0, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//                self.view.layoutIfNeeded()
//                }, completion: nil)
//        }
//        
//    }
//    
//    
//    
//    //Mark: UIImagePickerDelegate
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
//        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
//        
//        photoImageView.image = selectedImage
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController){
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    //CLLocationManagerDelegate
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
//        print(error.localizedDescription)
//    }
//    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
//        clLocationManager.stopUpdatingLocation()
//        //print(locations)
//        
//        let myCurrentLocation = locations[0]
//        
//        //geocoder
//        CLGeocoder().reverseGeocodeLocation(myCurrentLocation) { (myPlacements, myError) in
//            if (myError != nil){
//                
//            }
//            if let myPlacement = myPlacements?[0]{
//                self.address = "\(myPlacement.locality!), \(myPlacement.administrativeArea!)"
//                //print(self.address)
//                
//            }
//        }
//        
//    }
//    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
//        switch status {
//        case .Denied:
//            clLocationManager.stopUpdatingLocation()
//            break
//        case .AuthorizedWhenInUse:
//            clLocationManager.startUpdatingLocation()
//            break
//        default:
//            break
//        }
//    }
//
//
//}
//
//
//
//
//
//
//
//
