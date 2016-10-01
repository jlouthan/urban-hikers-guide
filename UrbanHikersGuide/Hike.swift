//
//  Hike.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 9/30/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//


struct Hike {
    
    //MARK: properties
    
    let name: String
    let distance: Double
    let description: String
    let difficulty: Difficulty
    
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
    }
    
}