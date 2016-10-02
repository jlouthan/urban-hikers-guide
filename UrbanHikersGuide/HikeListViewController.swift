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
        [
            "name": "Hike 1",
            "distance": 4.5,
            "description": "This is the first hike.",
            "mapImageUrl": "https://drzetlglcbfx.cloudfront.net/routes/thumbnail/1294139323/1475258232?size=600x600",
            "kmlFileUrl": "https://oauth2-api.mapmyapi.com/v7.1/route/1294139323/?format=kml&field_set=detailed",
            "gpxFileUrl": "https://oauth2-api.mapmyapi.com/v7.1/route/1294139323/?format=gpx&field_set=detailed"
        ],
        [
            "name": "Hike 2",
            "distance": 2.5,
            "description": "This is the second hike.",
            "mapImageUrl": "https://drzetlglcbfx.cloudfront.net/routes/thumbnail/1294135363/1475258232?size=600x600",
            "kmlFileUrl": "https://oauth2-api.mapmyapi.com/v7.1/route/1294135363/?format=kml&field_set=detailed",
            "gpxFileUrl": "https://oauth2-api.mapmyapi.com/v7.1/route/1294135363/?format=gpx&field_set=detailed"
        ]
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
        let hike = hikes[indexPath.row]
        print("Clicked hike \(hike)")
        
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

