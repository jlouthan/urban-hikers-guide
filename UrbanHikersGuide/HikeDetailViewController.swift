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
    var favoriteBtn: UIButton!
    
    override func viewDidLoad() {
        
        favoriteBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        //TODO possibly use a different image for favoriting. Or credit source http://www.flaticon.com/
        updateFavoriteBtnImage()
        favoriteBtn.addTarget(self, action: #selector(toggleFavorite(_:)), forControlEvents: .TouchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteBtn)
        
        //Remove long "Overview" text from next view back button
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        nameLabel.text = hike.name
        descriptionTextView.text = hike.overview
    }
    
    @IBAction func showMapView(sender: UIButton) {
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        controller.hike = hike
        navigationController!.pushViewController(controller, animated: true)
    }
    
    //MARK: Favoriting the hike
    
    func toggleFavorite (sender: UIBarButtonSystemItem) {
        hike.isFavorite = !hike.isFavorite
        updateFavoriteBtnImage()
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func updateFavoriteBtnImage() {
        if hike.isFavorite {
            favoriteBtn.setImage(UIImage(named: "favoriteOn"), forState: .Normal)
        } else {
            favoriteBtn.setImage(UIImage(named: "favoriteOff"), forState: .Normal)
        }
    }
}