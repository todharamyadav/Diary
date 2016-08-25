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
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.image = UIImage(named: "Profile")
        return imageView
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
        //tf.backgroundColor = UIColor.redColor()
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
        //tf.backgroundColor = UIColor.blueColor()
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
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = UIColor.blueColor()
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleRegister), forControlEvents: .TouchUpInside)
        return button
    }()
    
    func handleRegister(){
        guard let email = emailTextField.text, password = passwordTextField.text else{
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil{
                print(error)
                return
            }
            
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.greenColor()

        setUpLoginView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setUpLoginView(){
        view.addSubview(loginContainerView)
        view.addSubview(registerButton)
        view.addSubview(profileImageView)
        
        
        view.addConstraintsWithFormat("H:|-12-[v0]-12-|", views: loginContainerView)
         view.addConstraintsWithFormat("H:|-12-[v0]-12-|", views: registerButton)
        view.addConstraintsWithFormat("H:|-100-[v0(200)]", views: profileImageView)
        
        view.addConstraintsWithFormat("H:|-12-[v0]-12-|", views: registerButton)
        
        view.addConstraintsWithFormat("V:|-150-[v0(200)]-2-[v1]-2-[v2(40)]-200-|", views: profileImageView, loginContainerView, registerButton)
        
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
        
        loginContainerView.addConstraintsWithFormat("V:|[v0][v1(0.5)][v2][v3(0.5)][v4]|", views: nameTextField, nameBorder, emailTextField, emailBorder, passwordTextField)
        
        let heightConstriantName = NSLayoutConstraint(item: nameTextField, attribute: .Height, relatedBy: .Equal, toItem: loginContainerView, attribute: .Height, multiplier: 1/3, constant: loginContainerView.frame.size.height)
        
        let heightConstriantEmail = NSLayoutConstraint(item: emailTextField, attribute: .Height, relatedBy: .Equal, toItem: loginContainerView, attribute: .Height, multiplier: 1/3, constant: loginContainerView.frame.size.height)
        
        loginContainerView.addConstraints([heightConstriantName, heightConstriantEmail])
    }
    

}










