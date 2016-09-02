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
        
        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        guard let albumID = album?.albumID else{
            return
        }
        
        let ref = FIRDatabase.database().reference().child("Stories")
        let childRef = ref.childByAutoId()

        let values = ["storyPost": postTextView.text!, "storyDate": timestamp]
        
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
