//
// Created by Denis Kapusta on 7/11/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

class DKManagedObjectMapContext: MapContext {
    let ctx: NSManagedObjectContext

    init(context ctx: NSManagedObjectContext) {
        self.ctx = ctx
    }
}
