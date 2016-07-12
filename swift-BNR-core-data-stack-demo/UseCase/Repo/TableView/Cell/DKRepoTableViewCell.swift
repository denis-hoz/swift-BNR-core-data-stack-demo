//
// Created by Denis Kapusta on 6/6/16.
// Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import UIKit

protocol DKRepoUpdatable {
    func updateWithRepo(repo: DKRepo)
}

class DKRepoTableViewCell: UITableViewCell {
}

extension DKRepoTableViewCell: DKRepoUpdatable {
    func updateWithRepo(repo: DKRepo) {
        textLabel!.text = repo.name
        detailTextLabel!.text = "\(repo.stars)🌟 pushed: \(repo.pushedAt?.toString())"
    }
}
