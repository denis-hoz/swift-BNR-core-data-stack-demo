//
//  DKRepo.swift
//  swift-BNR-core-data-stack-demo
//
//  Created by Denis Kapusta on 7/8/16.
//  Copyright © 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper
import CoreDataStack

class DKRepo: NSManagedObject, Mappable, CoreDataModelable {
    // MARK: CoreDataModelable
    static var entityName = "DKRepo"
    
    // MARK: Mappable
    convenience required init?(_ map: Map) {
        var context: DKManagedObjectMapContext?
        if let _context = map.context as? DKManagedObjectMapContext  {
            context = _context
        } else {
            return nil
        }
        // This will throw an exception if context is null, that's ok, it should.
        let entity = NSEntityDescription.entityForName("DKRepo", inManagedObjectContext: context!.ctx)
        self.init(entity: entity!, insertIntoManagedObjectContext: context!.ctx)
        mapping(map)
    }

    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        stars <- map["stargazers_count"]
        pushedAt <- (map["pushed_at"], ISO8601DateTransform())
    }

}


