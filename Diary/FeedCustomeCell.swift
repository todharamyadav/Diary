//
//  FeedCustomeCell.swift
//  Diary
//
//  Created by Dharamvir on 9/3/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UICollectionViewCell{
    
    var heightConstraint: NSLayoutConstraint?
    
    var story: Story?{
        didSet{
            var attributedText = NSMutableAttributedString()
            
            if let uid = FIRAuth.auth()?.currentUser?.uid{
                let ref = FIRDatabase.database().reference().child("users").child(uid)
                ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        
                        attributedText = NSMutableAttributedString(string: "\(dictionary["name"] as! String)", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
                        
                        if let seconds = self.story?.storyDate?.doubleValue{
                            let timeStampDate = NSDate(timeIntervalSince1970: seconds)
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
                            
                            attributedText.appendAttributedString(NSAttributedString(string: "\n\(dateFormatter.stringFromDate(timeStampDate))", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12),NSForegroundColorAttributeName: UIColor.lightGrayColor()]))
                            
                        }
                        
                        if let storyLocation = self.story?.storyLocation{
                            attributedText.appendAttributedString(NSAttributedString(string: "\n\(storyLocation)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12),NSForegroundColorAttributeName: UIColor.lightGrayColor()]))
                        }
                        
                        if let profileImageUrl = dictionary["profileImageUrl"] as? String{
                            self.profileImageview.loadImagWithCacheAndUrlString(profileImageUrl)
                        }
                        self.nameLabel.attributedText = attributedText
                    }
                    
                    }, withCancelBlock: nil)
                
            }
            
            statusLabel.text = story?.storyPost
            if (story!.storyImage!.isEmpty){
                heightConstraint?.constant = 0
            }else{
                heightConstraint?.constant = 200
                statusImageView.loadImagWithCacheAndUrlString((story?.storyImage)!)
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
        label.text = "Mark"
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
    
    let statusLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        return label
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
        addSubview(statusLabel)
        addSubview(statusImageView)
        
        
        addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: profileImageview, nameLabel)
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: statusLabel)
        addConstraintsWithFormat("H:|[v0]|", views: statusImageView)
        
        
        addConstraintsWithFormat("V:|-8-[v0]", views: nameLabel)
        addConstraintsWithFormat("V:|-8-[v0(44)]-4-[v1]-4-[v2]|", views: profileImageview, statusLabel, statusImageView)
        
        heightConstraint = NSLayoutConstraint(item: statusImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200)
        addConstraint(heightConstraint!)
        
    }
}
