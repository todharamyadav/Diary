//
//  AddPostViewControllerHandler.swift
//  Diary
//
//  Created by Dharamvir on 8/22/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//

import UIKit
import Firebase

extension AddPostViewController {
    
    func saveData(){
        var profileImageUrl: String?
        
        let imageName = NSUUID().UUIDString
        let storageRef = FIRStorage.storage().reference().child("Post_Images").child("\(imageName).png")
        
        if let locImage = photoImageView.image{
            let uploadData = UIImageJPEGRepresentation(locImage, 0.1)
            storageRef.putData(uploadData!, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error)
                    return
                }
                profileImageUrl = metadata?.downloadURL()?.absoluteString
                self.saveStoryToDatabase(profileImageUrl!)
                })
        }else{
            profileImageUrl = ""
            saveStoryToDatabase(profileImageUrl!)
        }
    }
    
    private func saveStoryToDatabase(profileImageUrl: String){
        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        guard let albumID = album?.albumID else{
            return
        }
        
        let ref = FIRDatabase.database().reference().child("Stories")
        let childRef = ref.childByAutoId()
        
        let values = ["storyPost": postTextView.text, "storyDate": timestamp, "storyImage": profileImageUrl, "storyLocation": address!]
        
        //childRef.updateChildValues(values)
        childRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error)
                return
            }
            
            let userAlbumRef = FIRDatabase.database().reference().child("Album-Stories").child(albumID)
            let storyID = childRef.key
            userAlbumRef.updateChildValues([storyID: 1])
        })
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
