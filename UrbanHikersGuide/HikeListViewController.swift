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
        
        //If we don't have any hikes yet, make network request to get them
        if let hikeObjects = fetchedResultsController.fetchedObjects where hikeObjects.isEmpty {
            getHikes()
        }
    }
    
    func getHikes() {
        //Eventually these will be put in core data instead
        UnderArmourClient.sharedInstance().getAllRoutes { (success, hikeDictionaries) in
            guard success == true, let hikeArray = hikeDictionaries else {
                print("An Error occurred retrieving Hike data.")
                //TODO show an error message in the UI as well here
                return
            }
            
            for hikeDict in hikeArray {
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
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let hike = fetchedResultsController.objectAtIndexPath(indexPath) as! Hike
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("HikeDetailViewController") as! HikeDetailViewController
        controller.hike = hike
        navigationController!.pushViewController(controller, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HikeCell")!
        let hike = fetchedResultsController.objectAtIndexPath(indexPath) as! Hike;
        
        cell.textLabel?.text = hike.name
        cell.detailTextLabel?.text = "\(23) mi, \(hike.difficulty)"

//        cell.detailTextLabel?.text = "\(hike.distance) mi, \(hike.difficulty)"
        
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
    

}

