//
//  HikeListViewController.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 9/30/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import UIKit

class HikeListViewController: UITableViewController {
    
    let hikeArray = [
        ["name": "Hike 1", "distance": 4.5, "description": "This is the first hike."],
        ["name": "Hike 2", "distance": 2.5, "description": "This is the second hike."]
    ]
    
    var hikes = [Hike]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Eventually these will be put in core data instead
        for hikeDict in hikeArray {
            let newHike = Hike(dictionary: hikeDict)
            hikes.append(newHike)
        }
    }
    
    //MARK: Table View Delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hikes.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let hikeName = hikes[indexPath.row]
        print("Clicked hike \(hikeName)")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HikeCell")!
        
        let hike = hikes[indexPath.row]
        cell.textLabel?.text = hike.name
        cell.detailTextLabel?.text = "\(hike.distance) mi, \(hike.difficulty)"
        
        return cell
    }

}

