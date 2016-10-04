//
//  Hike.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 9/30/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import UIKit

struct Hike {
    
    //MARK: properties
    
    let name: String
    let distance: Double
    let description: String
    let difficulty: Difficulty
    let mapImage: UIImage?
    var isFavorite: Bool = false
    
    let kmlUrl: NSURL?
    let gpxUrl: NSURL?
    
    enum Difficulty: Int {
        case easy = 1, moderate, difficult
    }
    
    //MARK : Initializers
    init(dictionary: [String:AnyObject]) {
        name = dictionary["name"] as! String
        distance = dictionary["distance"] as! Double
        description = dictionary["description"] as! String
        
        //TODO make this a computed property instead?
        difficulty = Difficulty(rawValue: 2)!
        
        let imgUrl = dictionary["mapImageUrl"] as! String
        let imgData = NSData(contentsOfURL: NSURL(string: imgUrl)!)
        mapImage = UIImage(data: imgData!)
        if let isFav = dictionary["isFavorite"] as? Bool {
            isFavorite = isFav
        }
        
        kmlUrl = NSURL(string: dictionary["kmlFileUrl"] as! String)
        gpxUrl = NSURL(string: dictionary["gpxFileUrl"] as! String)
    }
    
}