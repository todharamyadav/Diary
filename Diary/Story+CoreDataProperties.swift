//
//  Story+CoreDataProperties.swift
//  Diary
//
//  Created by Dharamvir on 8/22/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Story {

    @NSManaged var status: String?
    @NSManaged var address: String?
    @NSManaged var date: NSDate?
    @NSManaged var locationImage: NSData?

}
