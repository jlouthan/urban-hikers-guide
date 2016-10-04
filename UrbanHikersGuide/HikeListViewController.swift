//
//  HikeListViewController.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 9/30/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import UIKit
import CoreData

class HikeListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Start the fetched results controller
        var error: NSError?
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
        }
        
        if let error = error {
            print("Error performing initial fetch: \(error)")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //If we don't have any hikes yet, make network request to get them
        if let hikeObjects = fetchedResultsController.fetchedObjects where hikeObjects.isEmpty {
            getHikes()
        }
    }
    
    func getHikes() {
        
        UnderArmourClient.sharedInstance().getAllRoutes { (success, hikeDictionaries) in
            guard success == true, let hikeArray = hikeDictionaries else {
                print("An Error occurred retrieving Hike data.")
                //TODO show an error message in the UI as well here
                return
            }
            
            for hikeDict in hikeArray {
                //Hike dictionaries are parsed appropriately by the UA Client, so we just
                // have to call Hike init method for each
                let hike = Hike(dictionary: hikeDict, context: self.sharedContext)
            }
            
            performUIUpdatesOnMain({
                //Save the hikes and reload the table
                CoreDataStackManager.sharedInstance().saveContext()
                self.tableView.reloadData()
            })
        }
    }
    
    
    //MARK: Table View Delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = fetchedResultsController.sections![section]
        return section.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let hike = fetchedResultsController.objectAtIndexPath(indexPath) as! Hike
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("HikeDetailViewController") as! HikeDetailViewController
        controller.hike = hike
        navigationController!.pushViewController(controller, animated: true)
    }
    
    func configureCell(cell: HikeTableViewCell, withHike hike: Hike) {
        cell.hikeTitle.text = hike.name
        cell.hikeDetails.text = "\(hike.distance) mi, \(hike.difficulty)"
        if hike.isFavorite {
            cell.favoriteImageView.image = UIImage(named: "favoriteOn")
        } else {
            cell.favoriteImageView.image = nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HikeCell") as! HikeTableViewCell
        let hike = fetchedResultsController.objectAtIndexPath(indexPath) as! Hike;
        configureCell(cell, withHike: hike)
        
        return cell
    }
    
    //MARK: Core Data
    
    var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Hike")
        //TODO sort by distance too if specified
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.sharedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
        
    }()
    
    //FetchedResultsController delegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    //Some of these cases are unlikely or impossible with the MVP of this app, but want
    // to have them all well-defined to futureproof
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            //In event of update, reconfigure cell with updated Hike info
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! HikeTableViewCell
            let hike = controller.objectAtIndexPath(indexPath!) as! Hike
            configureCell(cell, withHike: hike)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

}

