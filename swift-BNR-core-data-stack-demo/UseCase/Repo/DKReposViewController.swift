//
//  DKReposViewController.swift
//  swift-realm-notifications-demo
//
//  Created by Denis Kapusta on 6/3/16.
//  Copyright (c) 2016 Denis Kapusta Demo. All rights reserved.
//

import UIKit
import CoreDataStack

typealias ReposFetchedResultsController = FetchedResultsController<DKRepo>
typealias ReposObjectChange = FetchedResultsObjectChange<DKRepo>
typealias ReposSectionChange = FetchedResultsSectionChange<DKRepo>

class DKReposViewController: UIViewController {
    internal var coreDataStack: CoreDataStack!
    private lazy var fetchedResultsController: ReposFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: DKRepo.entityName)
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "pushedAt", ascending: false)]
        let frc = ReposFetchedResultsController(fetchRequest: fetchRequest,
                                                managedObjectContext: self.coreDataStack.mainQueueContext)
        frc.setDelegate(self.frcDelegate)
        return frc
    }()
    private lazy var frcDelegate: BooksFetchedResultsControllerDelegate = {
        return BooksFetchedResultsControllerDelegate(tableView: self.tableView)
    }()
    
    private lazy var gitHubAPI: DKGitHubAPIProviding = {
        return DKGitHubAPI(coreDataStack: self.coreDataStack)
    }()
    
	@IBOutlet var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch objects: \(error)")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        gitHubAPI.fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DKReposViewController {
    func indexPaths(forInsertions insertions: [Int]) -> [NSIndexPath] {
        return insertions.map( indexPathForRow )
    }
    
    func indexPathForRow(row: Int) -> NSIndexPath {
        return NSIndexPath(forRow: row, inSection: 0)
    }
}

extension DKReposViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].objects.count ?? 0
    }

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("DKRepoTableViewCell", forIndexPath: indexPath) as! DKRepoTableViewCell
		cell.updateWithRepo(fetchedResultsController.fetchedObjects![indexPath.row])
		
        return cell
    }

}

class BooksFetchedResultsControllerDelegate: FetchedResultsControllerDelegate {
    
    private weak var tableView: UITableView?
    
    // MARK: - Lifecycle
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func fetchedResultsControllerDidPerformFetch(controller: ReposFetchedResultsController) {
        tableView?.reloadData()
    }
    
    func fetchedResultsControllerWillChangeContent(controller: ReposFetchedResultsController) {
        tableView?.beginUpdates()
    }
    
    func fetchedResultsControllerDidChangeContent(controller: ReposFetchedResultsController) {
        tableView?.endUpdates()
    }
    
    func fetchedResultsController(controller: ReposFetchedResultsController,
                                  didChangeObject change: FetchedResultsObjectChange<DKRepo>) {
        switch change {
        case let .Insert(_, indexPath):
            tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        case let .Delete(_, indexPath):
            tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        case let .Move(_, fromIndexPath, toIndexPath):
            tableView?.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
            
        case let .Update(_, indexPath):
            tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func fetchedResultsController(controller: ReposFetchedResultsController,
                                  didChangeSection change: FetchedResultsSectionChange<DKRepo>) {
        switch change {
        case let .Insert(_, index):
            tableView?.insertSections(NSIndexSet(index: index), withRowAnimation: .Automatic)
            
        case let .Delete(_, index):
            tableView?.deleteSections(NSIndexSet(index: index), withRowAnimation: .Automatic)
        }
    }
}
