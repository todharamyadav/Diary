//
//  Album+CoreDataProperties.swift
//  Diary
//
//  Created by Dharamvir on 8/24/16.
//  Copyright © 2016 Dharamvir. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Album {

    @NSManaged var albumDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var stories: NSSet?

}
