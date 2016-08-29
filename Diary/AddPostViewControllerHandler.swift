////
////  AddPostViewControllerHandler.swift
////  Diary
////
////  Created by Dharamvir on 8/22/16.
////  Copyright © 2016 Dharamvir. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//extension AddPostViewController {
//    
//    
//    
//    func saveData(){
//        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
//        if let context = delegate?.managedObjectContext{
//            let newStory = NSEntityDescription.insertNewObjectForEntityForName("Story", inManagedObjectContext: context) as! Story
//            
//            if((postTextView.text) != nil){
//                newStory.status = postTextView.text
//            }
//            
//            if ((photoImageView.image) != nil) {
//                newStory.locationImage = UIImagePNGRepresentation(photoImageView.image!)
//            }
//            
//            if ((address) != nil){
//                newStory.address = address
//            }
//            
//            newStory.date = NSDate()
//            newStory.album = self.album
//            
//            do{
//                try context.save()
//            } catch let err{
//                print(err)
//            }
//        }
//        
//        self.navigationController?.popViewControllerAnimated(true)
//    }
//}
