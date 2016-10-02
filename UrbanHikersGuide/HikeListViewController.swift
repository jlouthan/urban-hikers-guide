//
//  HikeListViewController.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 9/30/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import UIKit

class HikeListViewController: UITableViewController {
    
    var hikes = [Hike]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Eventually these will be put in core data instead
        UnderArmourClient.sharedInstance().getAllRoutes { (success, hikeDictionaries) in
            guard success == true, let hikeArray = hikeDictionaries else {
                print("An Error occurred retrieving Hike data.")
                //TODO show an error message in the UI as well here
                return
            }
            
            for hikeDict in hikeArray {
                let newHike = Hike(dictionary: hikeDict)
                self.hikes.append(newHike)
            }
            
            performUIUpdatesOnMain({ 
                self.tableView.reloadData()
            })
        }
    }
    
    //MARK: Table View Delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hikes.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let hike = hikes[indexPath.row]
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("HikeDetailViewController") as! HikeDetailViewController
        controller.hike = hike
        navigationController!.pushViewController(controller, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HikeCell")!
        
        let hike = hikes[indexPath.row]
        cell.textLabel?.text = hike.name
        cell.detailTextLabel?.text = "\(hike.distance) mi, \(hike.difficulty)"
        
        return cell
    }

}

