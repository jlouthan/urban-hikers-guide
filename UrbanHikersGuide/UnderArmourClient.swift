//
//  UnderArmourClient.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 10/1/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import Foundation

class UnderArmourClient: NSObject {
    
    // shared request builder
    let requestBuilder = NetworkRequestBuilder.sharedInstance()
    
    //MARK: Helpers
    
    //Create a URL from parameters and method
    func underArmourURLWithMethod(parameters: [String: AnyObject], methodPath: String? = nil) -> NSURL {
        let components = NSURLComponents()
        components.scheme = API.APIScheme
        components.host = API.APIHost
        components.path = API.APIPath + (methodPath ?? "")
        
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    //MARK: Shared Instance
    class func sharedInstance() -> UnderArmourClient {
        struct Singleton {
            static var sharedInstance = UnderArmourClient()
        }
        return Singleton.sharedInstance
    }
}