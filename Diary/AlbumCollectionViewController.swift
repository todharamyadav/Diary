//
//  AlbumCollectionViewController.swift
//  Diary
//
//  Created by Dharamvir on 8/24/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
import CoreData
import Firebase

private let reuseIdentifier = "Cell"

class AlbumCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    func clearData(){
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext{
            
            do{
                let entityNames = ["Album"]
                
                for entityName in entityNames{
                    let fetchRequest = NSFetchRequest(entityName: entityName)
                    let objects = try (context.executeFetchRequest(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects!{
                        context.deleteObject(object)
                    }
                }
                
                try context.save()
                
            }catch let err{
                print(err)
            }
            
        }
    }
    
    lazy var fetchRequestController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Album")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "albumDate", ascending: false)]
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if type == .Insert{
            self.collectionView?.insertItemsAtIndexPaths([newIndexPath!])
        }
    }

    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //clearData()
        
//        let ref = FIRDatabase.database().referenceFromURL("https://diary-565a0.firebaseio.com/")
//        ref.updateChildValues(["someValue": 123123])
        
        collectionView?.alwaysBounceVertical = true
        self.collectionView!.registerClass(AlbumCustomCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addAlbum))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: #selector(logOut))
        navigationItem.title = "Album"
        
        do{
            try fetchRequestController.performFetch()
        } catch let err{
            print(err)
        }
        
    }
    
    func logOut(){
        let loginController = LoginViewController()
        presentViewController(loginController, animated: true, completion: nil)
    }
    
    func addAlbum(){
        let alert = UIAlertController(title: "Album", message: "Enter New Album Name", preferredStyle: .Alert)
        
        let saveButton = UIAlertAction(title: "Save", style: .Default) { (action) in
            let textField = alert.textFields![0] as UITextField
            
            //self.nameLabel.text = textField.text
            let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            if let context = delegate?.managedObjectContext{
                
                
                if textField.text == "" {
                    print("Please enter album name")
                }else{
                    let newAlbum = NSEntityDescription.insertNewObjectForEntityForName("Album", inManagedObjectContext: context) as! Album
                    
                    newAlbum.name = textField.text
                    newAlbum.albumDate = NSDate()
                    
                    do{
                        try context.save()
                    } catch let err{
                        print(err)
                    }

                }
            }

        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        alert.addTextFieldWithConfigurationHandler(nil)
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        
        presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let count = fetchRequestController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AlbumCustomCell
    
        // Configure the cell
        let currAlbum = fetchRequestController.objectAtIndexPath(indexPath) as! Album
        
        cell.album = currAlbum
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let layout = UICollectionViewFlowLayout()
        let controller = FeedViewController(collectionViewLayout: layout)
        let album = fetchRequestController.objectAtIndexPath(indexPath) as! Album
        controller.album = album
        navigationController?.pushViewController(controller, animated: true)
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

class AlbumCustomCell: UICollectionViewCell {
    
    var album: Album? {
        didSet{
            albumLabel.text = album?.name
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.layer.borderColor = UIColor.greenColor().CGColor
        imageView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 224/255, alpha: 1)
        imageView.image = UIImage(named: "Default_Image")
        return imageView
    }()
    
    let albumLabel: UILabel = {
        let label = UILabel()
        label.text = "Trip to Paris"
        label.font = UIFont.systemFontOfSize(18)
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor(red: 210/255, green: 105/255, blue: 30/255, alpha: 1)
        label.textAlignment = .Center
        return label
    }()
    
    func setUpViews(){
        addSubview(albumImageView)
        addSubview(albumLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: albumImageView)
        addConstraintsWithFormat("H:|[v0]|", views: albumLabel)
        
        addConstraintsWithFormat("V:|[v0(165)][v1]|", views: albumImageView, albumLabel)
    }
}










