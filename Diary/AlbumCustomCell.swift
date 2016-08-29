//
//  AlbumCustomCell.swift
//  Diary
//
//  Created by Dharamvir on 8/28/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit

class AlbumCustomCell: UICollectionViewCell {
    
//    var album: Album? {
//        didSet{
//            albumLabel.text = album?.name
//            
//        }
//    }
    
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
