//
//  NavControllerDelegate.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 11/2/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import UIKit

class NavControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait;
    }
    
}
