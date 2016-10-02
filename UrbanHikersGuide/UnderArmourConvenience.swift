//
//  UnderArmourConvenience.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 10/1/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import Foundation

extension UnderArmourClient {
    
    func getRouteById(routeId: String, completionHandlerForGetRouteById: (success: Bool, hikeDictionary: [String: AnyObject]?) -> Void) {
        
        //Creat the NSURL
        let parameters = [
            ParameterKeys.fieldSet: ParameterValues.fieldSet
        ]
        
        let methodPath = requestBuilder.substituteKeyInMethod(Methods.RouteById, key: URLKeys.RouteId, value: routeId)
        let url = underArmourURLWithMethod(parameters, methodPath: methodPath)
        
        //Make the request
        requestBuilder.taskForGETMethod(url, headers: API.CommonHeaders) { (result, error) in
            
            guard error == nil else {
                print(error)
                completionHandlerForGetRouteById(success: false, hikeDictionary: nil)
                return
            }
            
            //Make sure response has the fields we need for the hike
            guard let hikeName = result[ResponseKeys.HikeName] as? String,
                let hikeDistance = result[ResponseKeys.HikeDistance] as? Double,
                let hikeDescription = result[ResponseKeys.HikeDescription] as? String,
                let hikeLinks = result[ResponseKeys.HikeLinks] as? [String: AnyObject] else {
                    print("GetRouteById response does not contain all required Hike properties.")
                    completionHandlerForGetRouteById(success: false, hikeDictionary: nil)
                    return
            }
            
            //Get links for Hike files from more complex key paths
            //TODO generalize this?
            //TODO get bigger image!
            guard let hikeThumbs = hikeLinks["thumbnail"] as? [[String: AnyObject]],
                let hikeMapImageUrl = hikeThumbs[0]["href"] as? String else {
                    print("GetRouteById response does not contain expected Hike link properties.")
                    completionHandlerForGetRouteById(success: false, hikeDictionary: nil)
                    return
            }
            
            //TODO generalize this?
            guard let hikeFiles = hikeLinks["alternate"] as? [[String: AnyObject]],
                let hikeKmlFileUrl = hikeFiles[0]["href"] as? String,
                let hikeGpxFileUrl = hikeFiles[1]["href"] as? String else {
                    print("GetRouteById response does not contain expected Hike link properties")
                    completionHandlerForGetRouteById(success: false, hikeDictionary: nil)
                    return
            }
            
            //Get desired values from response
            let hikeDict = [
                "name": hikeName,
                "distance": hikeDistance,
                "description": hikeDescription,
                "mapImageUrl": "https:" + hikeMapImageUrl,
                "kmlFileUrl": "https://" + API.APIHost + hikeKmlFileUrl,
                "gpxFileUrl": "https://" + API.APIHost + hikeGpxFileUrl
            ]
            
            completionHandlerForGetRouteById(success: true, hikeDictionary: hikeDict as? [String : AnyObject])
            
        }
    }
    
    func getAllRoutes(completionHandlerForGetAllRoutes: (success: Bool, hikeDictionaries: [[String: AnyObject]]?) -> Void) {
        
        var storedError: String!
        var hikeDictionaries = [[String:AnyObject]]()
        let downloadGroup = dispatch_group_create()
        
        for routeId in API.HikeRouteIds {
            dispatch_group_enter(downloadGroup)
            getRouteById(routeId, completionHandlerForGetRouteById: { (success, hikeDictionary) in
                if let hike = hikeDictionary {
                    hikeDictionaries.append(hike)
                } else {
                    storedError = "Failed to get data for a Route"
                }
                dispatch_group_leave(downloadGroup)
            })
        }
        
        dispatch_group_notify(downloadGroup, dispatch_get_main_queue()) {
            guard storedError == nil else {
                print(storedError)
                completionHandlerForGetAllRoutes(success: false, hikeDictionaries: nil)
                return
            }
            completionHandlerForGetAllRoutes(success: true, hikeDictionaries: hikeDictionaries)
        }
    }
    
    //MARK: Helpers
//    
//    private func getHikeLink(forKey: [AnyObject], inHikeDict: [String: AnyObject]) -> String {
//        
//    }
}