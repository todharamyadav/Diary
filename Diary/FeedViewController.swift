//
//  ViewController.swift
//  Diary
//
//  Created by Dharamvir on 8/22/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
import CoreData

let cellID = "cellID"

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    
    func clearData(){
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext{
            
            do{
                let entityNames = ["Story"]
                
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
    
    lazy var fetchResultController: NSFetchedResultsController = {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Story")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addPost))
        
        navigationItem.title = "Events"
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellID)
        
        do{
            try fetchResultController.performFetch()
        } catch let err {
            print(err)
        }
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchResultController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! FeedCell
        
        let story = fetchResultController.objectAtIndexPath(indexPath) as! Story
        
        cell.post = story
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let story = fetchResultController.objectAtIndexPath(indexPath) as! Story
        
        if let statusText = story.status {
            let options = NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin)
            let rect = NSString(string: statusText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
            
            let calculatedHeight: CGFloat = 8+44+4+4+200
            
            if (story.locationImage != nil) {
                return CGSizeMake(view.frame.width, rect.height + calculatedHeight + 16)
            }
            
            
            
        }
        return CGSizeMake(view.frame.width, 300)
    }
    
    func addPost(){
        
        let controller = AddPostViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

}

class FeedCell: UICollectionViewCell{
    
    var heightConstraint: NSLayoutConstraint?
    let imageCache = NSCache()
    
    var post: Story? {
        didSet{
            
            let userDefault = NSUserDefaults.standardUserDefaults()
            
            if let name = userDefault.objectForKey("NAME") as? String{
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
                
                if let date = post?.date{
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MMMM dd, yyyy h:mm a"
                    
                    attributedText.appendAttributedString(NSAttributedString(string: "\n\(dateFormatter.stringFromDate(date))", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12),NSForegroundColorAttributeName: UIColor.lightGrayColor()]))
                    
                    if let location = post?.address{
                        attributedText.appendAttributedString(NSAttributedString(string: "\n\(location)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12),NSForegroundColorAttributeName: UIColor.lightGrayColor()]))
                    }
                    
                    nameLabel.attributedText = attributedText
                }
            }
            
            if let profileImageData =  userDefault.objectForKey("PROFILEIMAGE") as? NSData {
                profileImageview.image = UIImage(data: profileImageData)
            }

            
            if let statusText = post?.status{
                statusTextView.text = statusText
            }
            
            
            if let statusImage = post?.locationImage{
                
                var imageData: NSData?
                
                imageData = statusImage
                
                if let image = imageCache.objectForKey(statusImage) as? UIImage {
                    statusImageView.image = image
                    return
                }else{
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        let image = UIImage(data: statusImage)
                        
                        if imageData == statusImage{
                            self.statusImageView.image = image
                            
                        }
                        self.imageCache.setObject(image!, forKey: statusImage)
                        
                    })
                }
            }
        }
    }
    
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


extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String:  UIView]()
        for (index,view) in views.enumerate(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}







