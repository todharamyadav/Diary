//
//  LoginViewController.swift
//  Diary
//
//  Created by Dharamvir on 8/25/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var heightConstriantName: NSLayoutConstraint?
    var heighConstraintLoginController: NSLayoutConstraint?
    var settingController: SettingViewController?
    var albumController: AlbumCollectionViewController?
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.image = UIImage(named: "Profile")
        imageView.hidden = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadProfilePhoto)))
        imageView.userInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var loginSegmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.tintColor = UIColor.whiteColor()
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginSegmentControl), forControlEvents: .ValueChanged)
        return sc
    }()
    
    
    
    let loginContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 5
        return view
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        return tf
    }()
    
    let nameBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        return tf
    }()
    
    let emailBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.secureTextEntry = true
        //tf.backgroundColor = UIColor.cyanColor()
        return tf
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = UIColor.blueColor()
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 97/255, green: 183/255, blue: 127/255, alpha: 1)
        setUpLoginView()
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setUpLoginView(){
        view.addSubview(loginContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginSegmentControl)
        
        view.addConstraintsWithFormat("H:|-12-[v0]-12-|", views: loginContainerView)
        view.addConstraintsWithFormat("H:|-12-[v0]-12-|", views: loginRegisterButton)
        view.addConstraintsWithFormat("H:|-100-[v0(200)]", views: profileImageView)
        view.addConstraintsWithFormat("H:|-12-[v0]-12-|", views: loginSegmentControl)
        
        view.addConstraintsWithFormat("H:|-12-[v0]-12-|", views: loginRegisterButton)
        
        view.addConstraintsWithFormat("V:|-105-[v0(200)]-10-[v1(30)]-10-[v2]-2-[v3(40)]", views: profileImageView,loginSegmentControl, loginContainerView, loginRegisterButton)
        
        heighConstraintLoginController = NSLayoutConstraint(item: loginContainerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 98)
        view.addConstraint(heighConstraintLoginController!)
        
        setUpLoginContainerView()
    }
    
    func setUpLoginContainerView(){
        loginContainerView.addSubview(nameTextField)
        loginContainerView.addSubview(nameBorder)
        loginContainerView.addSubview(emailTextField)
        loginContainerView.addSubview(emailBorder)
        loginContainerView.addSubview(passwordTextField)
        
        loginContainerView.addConstraintsWithFormat("H:|-10-[v0]|", views: nameTextField)
        loginContainerView.addConstraintsWithFormat("H:|-10-[v0]|", views: emailTextField)
        loginContainerView.addConstraintsWithFormat("H:|-10-[v0]|", views: passwordTextField)
        loginContainerView.addConstraintsWithFormat("H:|[v0]|", views: nameBorder)
        loginContainerView.addConstraintsWithFormat("H:|[v0]|", views: emailBorder)
        
        loginContainerView.addConstraintsWithFormat("V:|[v0][v1(0.5)][v2(48)][v3][v4(48)]|", views: nameTextField, nameBorder, emailTextField, emailBorder, passwordTextField)
        
        heightConstriantName = NSLayoutConstraint(item: nameTextField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0)
        
        loginContainerView.addConstraint(heightConstriantName!)
    }
        

}










