//
//  extensions.swift
//  Diary
//
//  Created by Dharamvir on 8/28/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//
import UIKit

let imageCache = NSCache()
extension UIImageView{
    func loadImagWithCacheAndUrlString(urlString: String){
        self.image = nil
        
        //cache image if already downloaded
        if let cachedImage = imageCache.objectForKey(urlString) as? UIImage{
            self.image = cachedImage
            return
        }
        
        //download the image
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            if error != nil{
                print(error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString)
                    self.image = downloadedImage
                }
            })

        }.resume()
        
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
