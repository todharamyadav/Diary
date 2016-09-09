//
//  AlbumCustomCell.swift
//  Diary
//
//  Created by Dharamvir on 8/28/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
import Firebase

class AlbumCustomCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleToFill
        imageView.layer.borderColor = UIColor.greenColor().CGColor
        //imageView.backgroundColor = UIColor(red: 26/255, green: 175/255, blue: 226/255, alpha: 1)
        imageView.image = UIImage(named: "Default_Image")
        return imageView
    }()
    
    lazy var albumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(18)
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor(red: 26/255, green: 175/255, blue: 226/255, alpha: 1)
        label.textAlignment = .Center
        return label
    }()
    
        
    let deleteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Delete_Button")
        button.setImage(image, forState: .Normal)
        return button
    }()
    
    func setUpViews(){
        addSubview(albumImageView)
        addSubview(albumLabel)
        addSubview(deleteButton)
        
        addConstraintsWithFormat("H:|[v0]|", views: albumImageView)
        addConstraintsWithFormat("H:|[v0]|", views: albumLabel)
        addConstraintsWithFormat("H:[v0(40)]|", views: deleteButton)
        
        addConstraintsWithFormat("V:|[v0][v1(30)]|", views: albumImageView, albumLabel)
        addConstraintsWithFormat("V:|[v0(40)]", views: deleteButton)
    }
}
