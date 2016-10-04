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
    
    var session = NSURLSession.sharedSession()
    
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
    
    
    //Download helper Method
    
    //TODO move this to a networking class
    func downloadAndSaveMapFile(fileType: String, url: NSURL?) {
        //For now, use the shared session
        //TODO create custom session so I can set self to delegate
        // and receive handlers to indicate download activity?
        guard let url = url else {
            print("Hike does not have a \(fileType) file url. Aborting download")
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue("tmsv3uyh462u7fwqawhwy8stzdqsdzfs", forHTTPHeaderField: "Api-Key")
        request.addValue("Bearer 9fed1f01e0148dec037e751e2f4ebe7f57d929bc", forHTTPHeaderField: "Authorization")
        
        //TODO this callback could be moved to a handler to better monitor progress
        let task = session.downloadTaskWithRequest(request) { (url, response, error) in
            //TODO add all error handling
            
            guard let url = url else {
                print("No url returned from download request")
                return
            }
            
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
                try fileManager.copyItemAtURL(url, toURL: destinationUrl)
            } catch let error as NSError {
                print("Error moving file to disk: \(error.localizedDescription)")
            }
            
            //success saving file
            //TODO indicate success in the UI
            print("Download file and saved to \(destinationUrl)")
        }
        
        task.resume()
    }
}