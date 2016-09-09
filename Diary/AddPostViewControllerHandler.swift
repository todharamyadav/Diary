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
        
        let reachability = Reachability.reachabilityForInternetConnection()
        if reachability.currentReachabilityStatus().rawValue == 0{
            self.alertError("Error", message: "Could not be saved because of internet error or something else")
            
        }else{
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
    }
    
    private func saveStoryToDatabase(profileImageUrl: String){
        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        guard let albumID = album?.albumID else{
            return
        }
        
        if postTextView.text == placeholder{
            self.alertError("Error", message: "Please enter a description of the Event")
        }else{
            let ref = FIRDatabase.database().reference().child("Album-Stories").child(albumID)
            let storyRef = ref.childByAutoId()
            let storyID = storyRef.key
            let values = ["storyID": storyID, "storyPost": postTextView.text, "storyDate": timestamp, "storyImage": profileImageUrl, "storyLocation": address!]
            
            storyRef.updateChildValues(values)
            
            self.navigationController?.popViewControllerAnimated(true)

        }
    }
}
