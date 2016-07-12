//
// Created by Denis Kapusta on 6/3/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation
import Networking
import AFDateHelper
import ObjectMapper
import CoreDataStack

class DKGitHubAPI {
    let coreDataStack: CoreDataStack
    let restClient = DKRESTClient()

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}

// Mark: JSON type
typealias JSONDict = [String: AnyObject]
typealias JSONArray = Array<JSONDict>

extension _ArrayType where Generator.Element == JSONDict {
    func toRepos(inContext context: NSManagedObjectContext) -> [DKRepo] {
        let mapContext = DKManagedObjectMapContext(context: context)
        return self.flatMap( Mapper<DKRepo>(context: mapContext).map )
    }
}

extension DKGitHubAPI : DKGitHubAPIProviding{
    // MARK: fetch
    func fetch() {
        let workerContext = coreDataStack.mainQueueContext
        workerContext.performBlock() { [weak self] in
            self?.fetch(inContext: workerContext)
        }
    }
    
    func fetch(inContext context: NSManagedObjectContext) {
        restClient.fetchRepos { (JSON, error) in
            guard let JSON = JSON as? JSONArray else { return }
            JSON.toRepos(inContext: context)
            context.saveContext()
        }
    }
}
