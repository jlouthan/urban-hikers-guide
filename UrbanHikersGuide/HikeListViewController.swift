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
    @IBOutlet var refreshButton: UIBarButtonItem!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start the fetched results controller
        performFetch()
        
        //Standardize next page's back button text, since title of 
        // this page can change depending on sort/filter
        let backItem = UIBarButtonItem()
        backItem.title = "Hikes"
        navigationItem.backBarButtonItem = backItem
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
                let errorMessage = "An Error occurred retrieving Hike data. Inspect your network connection and try again."
                ErrorAlert.displayErrorAlert(errorMessage, currentView: self)
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
    
    //MARK: UIBarButtonItem actions
    
    @IBAction func showFavorites(sender: UIBarButtonItem) {
        
        if fetchedResultsController.fetchRequest.predicate != nil {
            //This means we're already showing favorites. Switch to showing all.
            fetchedResultsController.fetchRequest.predicate = nil

            navigationItem.setLeftBarButtonItem(refreshButton, animated: true)
            navigationItem.title = "All Hikes"
        } else {
            //This means we're not showing only favorites. Proceed to do so.
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(booleanLiteral: true))
            //Hide refresh option while showing favorite hikes
            navigationItem.leftBarButtonItem = nil
            navigationItem.title = "Favorite Hikes"
        }
        
        // re-fetch
        performFetch()
        
        performUIUpdatesOnMain { 
            self.tableView.reloadData()
        }
    }
    @IBAction func refreshHikes(sender: UIBarButtonItem) {
        //Try to delete all existing hikes
        do {
            let hikes = fetchedResultsController.fetchedObjects as! [Hike]
            for hike in hikes {
                sharedContext.deleteObject(hike)
            }
            //Save the context then get all fresh hikes
            try sharedContext.save()
            getHikes()
        } catch let error as NSError {
            let errorMessage = "Error refreshing hikes \(error)"
            ErrorAlert.displayErrorAlert(errorMessage, currentView: self)
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.sharedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
        
    }()
    
    //Perform a fetch
    func performFetch() {
        var error: NSError?
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
        }
        if let error = error {
            print("Error performing fetch: \(error)")
        }
    }
    
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

