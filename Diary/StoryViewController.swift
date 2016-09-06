//
//  StoryViewController.swift
//  Diary
//
//  Created by Dharamvir on 9/5/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit

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
    
    var storyCell: UITableViewCell = UITableViewCell()
    var imageCell: UITableViewCell = UITableViewCell()
    
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
        //image.image = UIImage(named: "Default_Image")
        return image
    }()
    
    override func loadView() {
        super.loadView()
        tableView.separatorStyle = .None
        tableView.allowsSelection = false
        
        storyCell.addSubview(storyLabel)
        imageCell.addSubview(storyImageView)
        
        storyCell.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: storyLabel)
        storyCell.addConstraintsWithFormat("V:|-8-[v0]-8-|", views: storyLabel)
        
        imageCell.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: storyImageView)
        imageCell.addConstraintsWithFormat("V:|-8-[v0]|", views: storyImageView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .Plain, target: self, action: #selector(shareStory))
        
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return self.storyCell
        case 1:
            return self.imageCell
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
        default:
            fatalError("Some Error")
        }
    }
    
}





