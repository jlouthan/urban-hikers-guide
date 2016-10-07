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
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        disappearAfter3Sec()
    }
    
    func disappearAfter3Sec() {
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            print("It's been 3 seconds!")
        }
    }
}