//
//  AlbumCollectionViewController.swift
//  Diary
//
//  Created by Dharamvir on 8/24/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
//import CoreData
import Firebase

private let reuseIdentifier = "Cell"

class AlbumCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        self.collectionView!.registerClass(AlbumCustomCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addAlbum))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: #selector(handleLogOut))
        
        checkIfUserIsLoggedIn()
        
        
    }
    var albums = [Album]()
    
    func observeUserAlbums(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("User-Album").child(uid)
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let albumID = snapshot.key
            let albumRef = FIRDatabase.database().reference().child("Albums").child(albumID)
            albumRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let album = Album()
                    album.setValuesForKeysWithDictionary(dictionary)
                    self.albums.append(album)
                    self.albums.sortInPlace({ (album1, album2) -> Bool in
                        return album1.albumDate?.intValue > album2.albumDate?.intValue
                    })
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectionView?.reloadData()
                    })
                }
                }, withCancelBlock: nil)
            }, withCancelBlock: nil)
        
    }
    
    func observeAlbums() {
        let ref = FIRDatabase.database().reference().child("Albums")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let album = Album()
                album.setValuesForKeysWithDictionary(dictionary)
                self.albums.append(album)
                self.albums.sortInPlace({ (album1, album2) -> Bool in
                    return album1.albumDate?.intValue > album2.albumDate?.intValue
                })
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.reloadData()
                })
            }
            
            }, withCancelBlock: nil)
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
    
    func setUpNavBarWithUser(user: User) {
        
        albums.removeAll()
        collectionView?.reloadData()
        observeUserAlbums()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //titleView.backgroundColor = UIColor.redColor()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let profileImageView = UIImageView()
        profileImageView.contentMode = .ScaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl{
            profileImageView.loadImagWithCacheAndUrlString(profileImageUrl)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = user.name
        
        titleView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        
        titleView.addConstraintsWithFormat("H:|[v0]", views: containerView)
        titleView.addConstraintsWithFormat("V:|[v0]|", views: containerView)
        
        containerView.addConstraintsWithFormat("H:|[v0(40)]-5-[v1]|", views: profileImageView, nameLabel)
        containerView.addConstraintsWithFormat("V:|[v0]|", views: profileImageView)
        
        containerView.addConstraintsWithFormat("V:|[v0]|", views: nameLabel)
        self.navigationItem.titleView = titleView
        
    }
    
    func handleLogOut(){
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutErr{
            print(logoutErr)
        }
        
        let loginController = LoginViewController()
        loginController.albumController = self
        presentViewController(loginController, animated: true, completion: nil)
    }
    
    func addAlbum(){
        let alert = UIAlertController(title: "Album", message: "Enter New Album Name", preferredStyle: .Alert)
        
        let saveButton = UIAlertAction(title: "Save", style: .Default) { (action) in
            let albumNameTextField = alert.textFields![0] as UITextField
            let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
            let userAlbum = FIRAuth.auth()!.currentUser!.uid
            
            let ref = FIRDatabase.database().reference().child("Albums")
            let childRef = ref.childByAutoId()
            let values = ["albumName": albumNameTextField.text!, "albumDate": timestamp, "userAlbum": userAlbum]
            
            //childRef.updateChildValues(values)
            childRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil{
                    print(error)
                    return
                }
                
                let userAlbumRef = FIRDatabase.database().reference().child("User-Album").child(userAlbum)
                let albumID = childRef.key
                userAlbumRef.updateChildValues([albumID: 1])
            })
            
            
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        alert.addTextFieldWithConfigurationHandler(nil)
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        
        presentViewController(alert, animated: true, completion: nil)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AlbumCustomCell
        
        let album = albums[indexPath.item]
        cell.albumLabel.text = album.albumName
    
        return cell
    }
    
//    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        let layout = UICollectionViewFlowLayout()
//        let controller = FeedViewController(collectionViewLayout: layout)
//
//        navigationController?.pushViewController(controller, animated: true)
//    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(2 - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(2))
        return CGSize(width: size, height: size)
    }
}











