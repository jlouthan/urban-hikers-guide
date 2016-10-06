//
//  ErrorAlert.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 10/5/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import Foundation
import UIKit

struct ErrorAlert {
    
    static func displayErrorAlert(errorMessage: String, currentView: UIViewController) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (UIAlertAction) in }
        alert.addAction(action)
        currentView.presentViewController(alert, animated: true) { }
        print(errorMessage)
    }
    
}