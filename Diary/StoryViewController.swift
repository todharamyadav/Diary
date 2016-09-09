//
//  StoryViewController.swift
//  Diary
//
//  Created by Dharamvir on 9/5/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
import Firebase

class StoryViewController: UITableViewController {
    
    var story: Story?{
        didSet{
            storyLabel.text = story?.storyPost
            if (story!.storyImage!.isEmpty){
            }else{
                storyImageView.loadImagWithCacheAndUrlString((story?.storyImage)!)
            }
        }
    }
    var album: Album?
    
    var storyCell: UITableViewCell = UITableViewCell()
    var imageCell: UITableViewCell = UITableViewCell()
    var emptyCell: UITableViewCell = UITableViewCell()
    var shareCell: UITableViewCell = UITableViewCell()
    
    let storyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(16)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        
        return label
    }()
    
    let storyImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .ScaleToFill
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        let titleColor = UIColor.whiteColor()
        button.setTitle("Share", forState: .Normal)
        button.setTitleColor(titleColor, forState: .Normal)
        button.backgroundColor = UIColor(red: 97/255, green: 183/255, blue: 127/255, alpha: 1)
        button.addTarget(self, action: #selector(shareStory), forControlEvents: .TouchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        tableView.separatorStyle = .None
        tableView.allowsSelection = false
        
        storyCell.addSubview(storyLabel)
        imageCell.addSubview(storyImageView)
        shareCell.addSubview(shareButton)
        
        storyCell.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: storyLabel)
        storyCell.addConstraintsWithFormat("V:|-8-[v0]-8-|", views: storyLabel)
        
        imageCell.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: storyImageView)
        imageCell.addConstraintsWithFormat("V:|-8-[v0]|", views: storyImageView)
        
        shareCell.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: shareButton)
        shareCell.addConstraintsWithFormat("V:|[v0]|", views: shareButton)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .Plain, target: self, action: #selector(deleteStory))
        
    }
    
    func shareStory(){
        if(story!.storyImage!.isEmpty){
            let UIActivityViewContrller = UIActivityViewController(activityItems: [storyLabel.text!], applicationActivities: nil)
            presentViewController(UIActivityViewContrller, animated: true, completion: nil)
            
        }
        else{
            let UIActivityViewContrller = UIActivityViewController(activityItems: [storyLabel.text!, storyImageView.image!], applicationActivities: nil)
            presentViewController(UIActivityViewContrller, animated: true, completion: nil)
        }

    }
    
    func deleteStory(){
        
        let deleteStoryController = UIAlertController(title: "Deleting Story", message: "Are you sure you want to delete this Event", preferredStyle: .ActionSheet)
        
        deleteStoryController.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) in
            print("Delete Pressed")
            if let albumID = self.album?.albumID{
                if let storyID = self.story?.storyID{
                    let ref = FIRDatabase.database().reference().child("Album-Stories").child(albumID).child(storyID)
                    ref.removeValue()
                }
                self.navigationController?.popViewControllerAnimated(true)
            }
            }))
        
        deleteStoryController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
            print("Cancel Pressed")
        }))
        self.presentViewController(deleteStoryController, animated: true, completion: nil)

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return self.storyCell
        case 1:
            return self.imageCell
        case 2:
            return self.emptyCell
        case 3:
            return self.shareCell
        default:
            fatalError("Some Error")
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            if let statusText = story!.storyPost{
                let options = NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin)
                let rect = NSString(string: statusText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil)
                return rect.height + 24 + 16
            }
            return 0
        case 1:
            return 400
        case 2:
            return 20
        case 3:
            return 40
        default:
            fatalError("Some Error")
        }
    }
    
}





