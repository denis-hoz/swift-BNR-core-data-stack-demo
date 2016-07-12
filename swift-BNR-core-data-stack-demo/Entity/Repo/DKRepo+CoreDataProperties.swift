//
//  DKRepo+CoreDataProperties.swift
//  swift-BNR-core-data-stack-demo
//
//  Created by Denis Kapusta on 7/8/16.
//  Copyright © 2016 Denis Kapusta Demo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DKRepo {

    @NSManaged var name: String?
    @NSManaged var id: NSNumber?
    @NSManaged var stars: NSNumber?
    @NSManaged var pushedAt: NSDate?

}
