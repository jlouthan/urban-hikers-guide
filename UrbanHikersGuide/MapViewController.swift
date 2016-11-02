//
//  MapViewController.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 10/1/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var hike: Hike!
    
    @IBOutlet weak var mapImageView: UIImageView!
    
    override func viewDidLoad() {
        if let mapImageData = hike.mapImageData {
            mapImageView.image = UIImage(data: mapImageData)
        }
        title = hike.name
    }

}