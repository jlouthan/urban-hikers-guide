//
//  Hike.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 9/30/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import UIKit
import CoreData

class Hike: NSManagedObject {
    
    //MARK: properties
    
    @NSManaged var name: String
    @NSManaged var distance: Double
    @NSManaged var overview: String
    var difficulty: Difficulty {
        get {
            return Difficulty(rawValue: 2)!
        }
    }
    @NSManaged var mapImageData: NSData?
    @NSManaged var isFavorite: Bool
    
    @NSManaged var kmlUrl: String
    @NSManaged var gpxUrl: String
    
    enum Difficulty: Int {
        case easy = 1, moderate, difficult
    }
    
    //Convert meters to miles, rounded to hundredth of a mile
    func metersToMiles(meters: Double) -> Double {
        return Double(round(100 * (meters / 1609.34) ) / 100)
    }
    
    //MARK : Initializers
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        //Get the entity associated with the Hike type
        let entity = NSEntityDescription.entityForName("Hike", inManagedObjectContext: context)!
        
        //Use the inherited init method from NSManagedObject
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        //Set the properties on the model
        name = dictionary["name"] as! String
        let distanceInMeters = dictionary["distance"] as! Double
        distance = metersToMiles(distanceInMeters)
        overview = dictionary["overview"] as! String
        
        let imgUrl = dictionary["mapImageUrl"] as! String
        mapImageData = NSData(contentsOfURL: NSURL(string: imgUrl)!)
        if let isFav = dictionary["isFavorite"] as? Bool {
            isFavorite = isFav
        }
        
        kmlUrl = dictionary["kmlFileUrl"] as! String
        gpxUrl = dictionary["gpxFileUrl"] as! String

    }
    
}