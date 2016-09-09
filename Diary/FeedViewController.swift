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
            navigationItem.title = album?.albumName
            
            stories.removeAll()
            collectionView?.reloadData()
            observeAlbumStories()
            observerDeletion()
        }
    }
    var stories = [Story]()
    
    override func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addPost))
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellID)
      
    }
    
    func observeAlbumStories(){
        
        guard let albumID = album?.albumID else{
            return
        }
        
        let ref = FIRDatabase.database().reference().child("Album-Stories").child(albumID)
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let storyID = snapshot.key
            let storyRef = ref.child(storyID)
            storyRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let story = Story()
                    story.setValuesForKeysWithDictionary(dictionary)
                    self.stories.append(story)
                    self.stories.sortInPlace({ (story1, story2) -> Bool in
                        return story1.storyDate?.intValue > story2.storyDate?.intValue
                    })
                }
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.collectionView?.reloadData()
                })
                
                }, withCancelBlock: nil)
            }, withCancelBlock: nil)
        
    }
    
    func indexOfStory(snapshot: FIRDataSnapshot) -> Int {
        var index = 0
        for  story in stories {
            
            if (snapshot.key == story.storyID) {
                return index
            }
            index += 1
        }
        return -1
    }
    
    func observerDeletion(){
        guard let albumID = album?.albumID else{
            return
        }
        
        let ref = FIRDatabase.database().reference().child("Album-Stories").child(albumID)
        ref.observeEventType(.ChildRemoved, withBlock: { (snapshot) in
            let index = self.indexOfStory(snapshot)
            self.stories.removeAtIndex(index)
            dispatch_async(dispatch_get_main_queue(),{
                self.collectionView?.reloadData()
            })
            }, withCancelBlock: nil)
        
    }
    
    func addPost(){
        
        let controller = AddPostViewController()
        controller.album = self.album
        navigationController?.pushViewController(controller, animated: true)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! FeedCell
        let story = stories[indexPath.item]
        
        cell.story = story
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedStory = stories[indexPath.item]
        let controller = StoryViewController()
        controller.story = selectedStory
        controller.album = self.album
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let story = stories[indexPath.item]
        let calculatedHeight: CGFloat = 8+44+4+4
        
        func calculatePostHeight() -> CGRect{
            let statusText = story.storyPost
            let options = NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin)
            let rect = NSString(string: statusText!).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
            return rect
        }
        
        if (story.storyImage!.isEmpty){
            print("empty")
            return CGSizeMake(view.frame.width, calculatePostHeight().height + calculatedHeight + 24)
            
        }else{
            print("not empty")
            return CGSizeMake(view.frame.width, calculatePostHeight().height + calculatedHeight + 24 + 200)
        }
        
    }
}









