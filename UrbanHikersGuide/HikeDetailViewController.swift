//
//  HikeDetailViewController.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 9/30/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import Foundation
import UIKit

class HikeDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var hike: Hike!
    
    override func viewDidLoad() {
        nameLabel.text = hike.name
        descriptionTextView.text = hike.description
    }
    @IBAction func showMapView(sender: UIButton) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        controller.hike = hike
        navigationController!.pushViewController(controller, animated: true)
    }
}