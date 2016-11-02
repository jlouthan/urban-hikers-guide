//
//  SplashScreenViewController.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 10/6/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import Foundation
import UIKit

class SplashScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 86/255, green: 166/255, blue: 91/255, alpha: 1.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        disappearAfter2Sec()
    }
    
    func disappearAfter2Sec() {
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            print("It's been 2 seconds!")
            let hikeListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
            self.presentViewController(hikeListViewController, animated: true, completion: {
                print("Showing new view controller")
            })
        }
    }
}
