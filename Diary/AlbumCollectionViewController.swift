//
//  AlbumCollectionViewController.swift
//  Diary
//
//  Created by Dharamvir on 8/24/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class AlbumCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate, UIActionSheetDelegate {
    
    var albums = [Album]()
    let reachability = Reachability.reachabilityForInternetConnection()

    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
        //checkIfUserIsLoggedIn()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        self.collectionView!.registerClass(AlbumCustomCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        checkIfUserIsLoggedIn()
    }
    
    
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
    
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            performSelector(#selector(handleLogOut), withObject: nil, afterDelay: 0)
            print("Need to log out")
        } else{
            setUpNavigationItemTitle()
            checkingInternet()
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
        
        print("Counting....")
        
        albums.removeAll()
        collectionView?.reloadData()
        observeUserAlbums()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
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
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.text = "Albums"//user.name
        
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
    
    func checkingInternet(){
        if reachability.currentReachabilityStatus().rawValue == 0{
            self.alertError("Error", message: "No Internet")
            
        }
    }
    
    func handleLogOut(){
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutErr{
            print(logoutErr)
        }
        
        let loginController = LoginViewController()
        loginController.albumController = self
        presentViewController(loginController, animated: true) { 
            self.checkingInternet()
        }
    }
    
    func addAlbum(){
        
        let alertController = UIAlertController(title: "Album Name", message: "New Album Name", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action) in
            if let albumNameTextField = alertController.textFields?.first {
                if (albumNameTextField.text!.isEmpty){
                    self.alertError("Error", message: "Please enter Album Name")
                }else if (self.reachability.currentReachabilityStatus().rawValue == 0){
                    self.alertError("Error", message: "Could not be saved because of internet error or something else")
                }else{
                    let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
                    let userAlbum = FIRAuth.auth()!.currentUser!.uid
                    
                    let ref = FIRDatabase.database().reference().child("Albums")
                    let childRef = ref.childByAutoId()
                    let albumID = childRef.key
                    let values = ["albumName": albumNameTextField.text!, "albumDate": timestamp, "userAlbum": userAlbum, "albumID": albumID]
                    
                    childRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if error != nil{
                            print(error)
                            return
                        }
                        
                        let userAlbumRef = FIRDatabase.database().reference().child("User-Album").child(userAlbum)
                        userAlbumRef.updateChildValues([albumID: 1])
                    })
                }
            }
            
        }))
        
        alertController.addTextFieldWithConfigurationHandler({ (textfield) in
            textfield.placeholder = "Album Name"
        })
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AlbumCustomCell
        
        if indexPath.item == albums.count{
            cell.albumImageView.image = UIImage(named: "New_Album")
            cell.albumLabel.backgroundColor = UIColor.whiteColor()
            cell.albumLabel.text = "Add New Album"
            cell.deleteButton.hidden = true
        }else{
            let album = albums[indexPath.item]
            cell.albumLabel.backgroundColor = UIColor(red: 26/255, green: 175/255, blue: 226/255, alpha: 1)
            setUpNameLabel(album.albumName!, label: cell.albumLabel)
            cell.albumImageView.image = UIImage(named: "Default_Image")
            
            cell.deleteButton.layer.setValue(indexPath.item, forKey: "index")
            cell.deleteButton.addTarget(self, action: #selector(deleteUser(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.deleteButton.hidden = false
            
            cell.albumLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editAlbumName(_:))))
            cell.albumLabel.tag = indexPath.item
            cell.albumLabel.userInteractionEnabled = true
        }
        return cell
    }
    
    func editAlbumName(tapRecognizer: UITapGestureRecognizer){
        
        if let i = tapRecognizer.view?.tag{
            let albumNum = albums[i]
            
            let alertController = UIAlertController(title: "Album Name", message: "Changed Album Name", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            alertController.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action) in
                if let textField = alertController.textFields?.first {
                    if (textField.text!.isEmpty){
                        self.alertError("Error", message: "Name field can't be empty")
                    }else if (self.reachability.currentReachabilityStatus().rawValue == 0){
                        self.alertError("Error", message: "Could not be saved because of internet error or something else")
                    }
                    else{
                        let indexPath = NSIndexPath(forItem: i, inSection: 0)
                        let cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as! AlbumCustomCell
                        
                        self.setUpNameLabel(textField.text!, label: cell.albumLabel)
                        
                        let ref = FIRDatabase.database().reference().child("Albums").child(albumNum.albumID!)
                        let values = ["albumName": textField.text!]
                        ref.updateChildValues(values)
                    }
                }

            }))
            
            alertController.addTextFieldWithConfigurationHandler({ (textfield) in
                textfield.placeholder = "Album Name"
            })
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func deleteUser(sender:UIButton){
        
        let i : Int = (sender.layer.valueForKey("index")) as! Int
        let albumNum = albums[i]
        
        if let albumName = albumNum.albumName{
            let deleteAlbumController = UIAlertController(title: "\(albumName)", message: "Are you sure you want to delete this album", preferredStyle: .ActionSheet)
            
            deleteAlbumController.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) in
                print("Delete Pressed")
                
                self.albums.removeAtIndex(i)
                
                guard let uid = FIRAuth.auth()?.currentUser?.uid else{
                    return
                }
                
                if let albumID = albumNum.albumID{
                    let ref = FIRDatabase.database().reference().child("User-Album").child(uid).child(albumID)
                    ref.removeValueWithCompletionBlock({ (error, ref) in
                        if error != nil{
                            print(error)
                            return
                        }
                        print("successful 1st")
                        let albumRef = FIRDatabase.database().reference().child("Albums").child(albumID)
                        albumRef.removeValueWithCompletionBlock({ (error, albumRef) in
                            if error != nil {
                                print(error)
                                return
                            }
                            print("successful 2nd")
                            let albumStoryRef = FIRDatabase.database().reference().child("Album-Stories").child(albumID)
                            albumStoryRef.removeValue()
                            print("successful 3rd")
                        })
                    })
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.reloadData()
                })

            }))
            
            deleteAlbumController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
                print("Cancel Pressed")
            }))
            self.presentViewController(deleteAlbumController, animated: true, completion: nil)
        }
        
    }

    func setUpNameLabel(name: String, label: UILabel){
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "Edit_Button")
        attachment.bounds = CGRectMake(5, -5, 30, 30)
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: name)
        myString.appendAttributedString(attachmentString)
        label.attributedText = myString
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.item == albums.count{
            addAlbum()
        }else{
            let selectedAlbum = albums[indexPath.item]
            let layout = UICollectionViewFlowLayout()
            let controller = FeedViewController(collectionViewLayout: layout)
            controller.album = selectedAlbum
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(2 - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(2))
        return CGSize(width: size, height: size)
    }
}











