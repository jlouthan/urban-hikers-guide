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
        //Add favorite bar button item
//        let favoriteBtn = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(favoriteHike(_:)))
//        navigationItem.rightBarButtonItem = favoriteBtn
        
        let favoriteBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        favoriteBtn.setImage(UIImage(named: "favoriteOn"), forState: .Normal)
        favoriteBtn.addTarget(self, action: #selector(favoriteHike(_:)), forControlEvents: .TouchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteBtn)
        
        nameLabel.text = hike.name
        descriptionTextView.text = hike.description
    }
    @IBAction func showMapView(sender: UIButton) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        controller.hike = hike
        navigationController!.pushViewController(controller, animated: true)
    }
    
    func favoriteHike (sender: UIBarButtonSystemItem) {
        print("Favoriting the hike!")
    }
}