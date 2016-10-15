//
//  Country+CoreDataProperties.swift
//  XaddressLoader
//
//  Created by Paul Von Schrottky on 10/15/16.
//  Copyright © 2016 Xaddress. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Country {

    @NSManaged var name: String?
    @NSManaged var code: String?
    @NSManaged var nameES: String?
    @NSManaged var lon: NSNumber?
    @NSManaged var lat: NSNumber?
    @NSManaged var bounds: String?
    @NSManaged var totalCombinations: NSNumber?
    @NSManaged var kind: String?

}
