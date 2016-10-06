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
    
    //Download File Actions
    
    @IBAction func downloadKml(sender: UIButton) {
        let kmlUrl = NSURL(string: hike.kmlUrl)
        downloadAndSaveMapFile("kml", url: kmlUrl)
    }
    
    @IBAction func downloadGpx(sender: UIButton) {
        let gpxUrl = NSURL(string: hike.gpxUrl)
        downloadAndSaveMapFile("gpx", url: gpxUrl)
    }
    
    
    //Mark: Download Map File and Save
    
    func downloadAndSaveMapFile(fileType: String, url: NSURL?) {
        
        guard let url = url else {
            print("Hike does not have a \(fileType) file url. Aborting download")
            return
        }
        
        UnderArmourClient.sharedInstance().downloadMapFile(url) { (success, responseUrl) in
            
            guard success == true && responseUrl != nil else {
                ErrorAlert.displayErrorAlert("Error downloading map file. Inspect your network connection and try again.", currentView: self)
                return
            }
            
            //Success, now save the downloaded file
            
            //Move the file to a permanent destination
            let fileManager = NSFileManager.defaultManager()
            
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
            
            let newFileName = "/" + self.hike.name.componentsSeparatedByString(" ").joinWithSeparator("-") + ".\(fileType)"
            let newFilePath = documentsPath.stringByAppendingString(newFileName)
            
            let destinationUrl = NSURL(fileURLWithPath: newFilePath)
            
            //Remove the file if it already exists
            do {
                try fileManager.removeItemAtURL(destinationUrl)
            } catch {
                //Not fatal
            }
            
            do {
                try fileManager.copyItemAtURL(responseUrl!, toURL: destinationUrl)
            } catch let error as NSError {
                print("Error moving file to disk: \(error.localizedDescription)")
            }
            
            //success saving file
            //TODO indicate success in the UI?
            print("Download file and saved to \(destinationUrl)")
            
        }

    }
}