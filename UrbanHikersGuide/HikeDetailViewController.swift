//
//  HikeDetailViewController.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 9/30/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import Foundation
import UIKit

class HikeDetailViewController: UIViewController{
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
        
        setViewContent()
    }
    
    func setViewContent() {
        nameLabel.text = hike.name
        descriptionTextView.text = hike.overview
        
        //Set the text view height to contain the text        
        let fixedWidth = descriptionTextView.frame.size.width
        descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = descriptionTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        descriptionTextView.frame = newFrame;
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
    
    //MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame;
    }
}