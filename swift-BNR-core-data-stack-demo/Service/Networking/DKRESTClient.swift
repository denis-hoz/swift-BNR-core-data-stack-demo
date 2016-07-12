//
// Created by Denis Kapusta on 6/6/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import Foundation
import Networking

let username = "realm"

class DKRESTClient {
    private
    let fetchReposPath = "/users/\(username)/repos?sort=pushed&direction=desc&type=owner"
    let networking = Networking(baseURL: "https://api.github.com")
}

extension DKRESTClient {
    func fetchRepos(completion: (JSON: AnyObject?, error: NSError?) -> ()) {
        networking.GET(fetchReposPath, completion: completion)
    }
}
