//
//  ViewController.swift
//  Diary
//
//  Created by Dharamvir on 8/22/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit

let cellID = "cellID"

class Post {
    var name: String?
    var statusText: String?
    var profileImage: String?
    var statusImage: String?
}

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var posts = [Post]()
    
    func addPost(){

        let controller = AddPostViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addPost))
       
        
//        let postMark = Post()
//        postMark.name = "Mark Zuckerberg"
//        postMark.statusText = "jvbsad sdvs vh shjvs ahbv svhjbs ashjvs ah a"
//        postMark.profileImage = "Mark"
//        postMark.statusImage = "Mark"
//        
//        let postSteve = Post()
//        postSteve.name = "Steve Jobs"
//        postSteve.statusText = "Jobs's countercultural lifestyle and philosophy was a product of the time and place of his upbringing. Jobs was adopted at birth in San Francisco, and raised in a hotbed of counterculture, the San Francisco Bay Area during the 1960s.[4] As a senior at Homestead High School in Cupertino, California, his two closest friends were the older engineering student (and Homestead High alumnus) Wozniak and his girlfriend, the artistically inclined and countercultural Homestead High junior Chrisann Brennan.[5] Jobs and Wozniak bonded over their mutual fascination with Jobs's musical idol Bob Dylan, discussing his lyrics and collecting bootleg reel-to-reel tapes of Dylan's concerts.[6] Jobs later dated Joan Baez who notably had a prior relationship with Dylan.[6] Jobs briefly attended Reed College in 1972 before dropping out.[5] He then decided to travel through India in 1974 seeking enlightenment and studying Zen Buddhism"
//        postSteve.profileImage = "Steve"
//        postSteve.statusImage = "Steve_Status"
//        
//        let postGandhi = Post()
//        postGandhi.name = "Mahatma Gandhi"
//        postGandhi.statusText = "Born and raised in a Hindu merchant caste family in coastal Gujarat, western India, and trained in law at the Inner Temple, London, Gandhi first employed nonviolent civil disobedience as an expatriate lawyer in South Africa, in the resident Indian community's struggle for civil rights. After his return to India in 1915, he set about organising peasants, farmers, and urban labourers to protest against excessive land-tax and discrimination. Assuming leadership of the Indian National Congress in 1921, Gandhi led nationwide campaigns for easing poverty, expanding women's rights, building religious and ethnic amity, ending untouchability, but above all for achieving Swaraj or self-rule"
//        postGandhi.profileImage = "Gandhi"
//        postGandhi.statusImage = "Gandhi_Status"
//        
//        posts.append(postMark)
//        posts.append(postSteve)
//        posts.append(postGandhi)
        
        navigationItem.title = "Events"
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellID)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! FeedCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let statusText = posts[indexPath.item].statusText{
            let options = NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin)
            let rect = NSString(string: statusText).boundingRectWithSize(CGSizeMake(view.frame.width, 1000), options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
            
            let calculatedHeight: CGFloat = 8+44+4+4+200
            
            return CGSizeMake(view.frame.width, rect.height + calculatedHeight + 16)
        }
        return CGSizeMake(view.frame.width, 300)
    }
}

class FeedCell: UICollectionViewCell{
    
    var post: Post? {
        didSet{
            if let name = post?.name{
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
                attributedText.appendAttributedString(NSAttributedString(string: "\nDecember 15, 2016 at 00:00 AM", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12),NSForegroundColorAttributeName: UIColor.lightGrayColor()]))
                attributedText.appendAttributedString(NSAttributedString(string: "\nSan Francisco, CA", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12),NSForegroundColorAttributeName: UIColor.lightGrayColor()]))
                nameLabel.attributedText = attributedText

            }
            
            if let statusText = post?.statusText{
                statusTextView.text = statusText
            }
            
            if let profileImage = post?.profileImage{
                profileImageview.image = UIImage(named: profileImage)
            }
            
            if let statusImage = post?.statusImage{
                statusImageView.image = UIImage(named: statusImage)
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
        image.contentMode = .ScaleAspectFit
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
        image.image = UIImage(named: "Mark")
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
        addConstraintsWithFormat("V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]|", views: profileImageview, statusTextView, statusImageView)
        
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







