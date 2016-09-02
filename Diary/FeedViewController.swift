//
//  ViewController.swift
//  Diary
//
//  Created by Dharamvir on 8/22/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
import Firebase

let cellID = "cellID"

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var album: Album?{
        didSet{
            print(album)
            navigationItem.title = album?.albumName
            observeAlbumStories()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tabBarController?.tabBar.hidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addPost))
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellID)
        //observeAlbumStories()
      
    }
    
    func observeAlbumStories(){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        
        let userReference = FIRDatabase.database().reference().child("User-Album").child(uid)
        userReference.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            //print(snapshot.key)
            let albumID = snapshot.key
            let albumRef = FIRDatabase.database().reference().child("Albums").child(albumID)
            albumRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                print(snapshot)
                }, withCancelBlock: nil)
            
            }, withCancelBlock: nil)
        
    }
    
    func addPost(){
        
        let controller = AddPostViewController()
        controller.album = self.album
        navigationController?.pushViewController(controller, animated: true)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let count = fetchResultController.sections?[0].numberOfObjects {
//            return count
//        }
        return 5
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! FeedCell
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        let story = fetchResultController.objectAtIndexPath(indexPath) as! Story
//        
//        if let statusText = story.status {
//            let options = NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin)
//            let rect = NSString(string: statusText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
//            
//            let calculatedHeight: CGFloat = 8+44+4+4+200
//            
//            if (story.locationImage != nil) {
//                return CGSizeMake(view.frame.width, rect.height + calculatedHeight + 16)
//            }
//        
//            
//            
//        }
        return CGSizeMake(view.frame.width, 300)
    }
    
    

}

class FeedCell: UICollectionViewCell{
    
    var heightConstraint: NSLayoutConstraint?
    let imageCache = NSCache()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        
        return label
        
    }()
    
    let profileImageview: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Mark")
        image.contentMode = .ScaleAspectFill
        image.layer.masksToBounds = true
        image.backgroundColor = UIColor.redColor()
        return image
    }()
    
    let statusTextView:UITextView = {
        let textView = UITextView()
        textView.text = "dfjv vjdfhv dfvjhd d "
        textView.font = UIFont.systemFontOfSize(14)
        textView.scrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .ScaleAspectFill
        image.layer.masksToBounds = true
        return image
    }()
    
    func setUpViews() {
        backgroundColor = UIColor.whiteColor()
        
        addSubview(nameLabel)
        addSubview(profileImageview)
        addSubview(statusTextView)
        addSubview(statusImageView)
        
        
        addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: profileImageview, nameLabel)
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat("H:|[v0]|", views: statusImageView)
        
        
        addConstraintsWithFormat("V:|-8-[v0]", views: nameLabel)
        addConstraintsWithFormat("V:|-8-[v0(44)]-4-[v1]-4-[v2]|", views: profileImageview, statusTextView, statusImageView)
        
        heightConstraint = NSLayoutConstraint(item: statusImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
        addConstraint(heightConstraint!)
        
    }
}










