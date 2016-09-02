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
        
        
        let ref = FIRDatabase.database().reference().child("Albums")
        let childRef = ref.childByAutoId()
        let albumID = childRef.key
        let values = ["albumName": albumNameTextField.text!, "albumDate": timestamp, "userAlbum": userAlbum, "albumID": albumID]
        
        //childRef.updateChildValues(values)
        childRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error)
                return
            }
            
            let userAlbumRef = FIRDatabase.database().reference().child("User-Album").child(userAlbum)
            //let albumID = childRef.key
            userAlbumRef.updateChildValues([albumID: 1])
        })
    
        self.navigationController?.popViewControllerAnimated(true)
    }
}
