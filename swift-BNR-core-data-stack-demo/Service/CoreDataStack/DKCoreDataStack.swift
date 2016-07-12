//
// Created by Denis Kapusta on 7/8/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation
import CoreDataStack

typealias DKCoreDataStackCompletion = (coreDataStack :CoreDataStack) -> ()

class DKCoreDataStack {
    private var coreDataStack: CoreDataStack?
    private let handler: DKCoreDataStackCompletion

    init(handler: DKCoreDataStackCompletion) {
        self.handler = handler
        setupDefaults()
    }

    func setupDefaults() {
        CoreDataStack.constructSQLiteStack(withModelName: "Model") { result in
            switch result {
            case .Success(let stack):
                self.coreDataStack = stack
                dispatch_async(dispatch_get_main_queue()) {
                    self.handler(coreDataStack: stack)
                }

            case .Failure(let error):
                assertionFailure("\(error)")
            }
        }
    }
}
