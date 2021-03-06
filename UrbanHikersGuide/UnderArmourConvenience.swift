//
//  UnderArmourConvenience.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 10/1/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import Foundation

extension UnderArmourClient {
    
    func getRouteById(accessToken: String, routeId: String, completionHandlerForGetRouteById: (success: Bool, hikeDictionary: [String: AnyObject]?) -> Void) {
        
        //Creat the NSURL
        let parameters = [
            ParameterKeys.fieldSet: ParameterValues.fieldSet
        ]
        
        let methodPath = requestBuilder.substituteKeyInMethod(Methods.RouteById, key: URLKeys.RouteId, value: routeId)
        let url = underArmourURLWithMethod(parameters, methodPath: methodPath)
        let headers = [
            HeaderKeys.APIKey: HeaderValues.APIKey,
            HeaderKeys.Authorization: "Bearer \(accessToken)"
        ]
        
        //Make the request
        requestBuilder.taskForGETMethod(url, headers: headers) { (result, error) in
            
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
            guard let hikeThumbs = hikeLinks["thumbnail"] as? [[String: AnyObject]],
                var hikeMapImageUrl = hikeThumbs[0]["href"] as? String else {
                    print("GetRouteById response does not contain expected Hike link properties.")
                    completionHandlerForGetRouteById(success: false, hikeDictionary: nil)
                    return
            }
            
            //Replace size in mapImageUrl to retrieve bigger image from cloudfront
            hikeMapImageUrl = hikeMapImageUrl.stringByReplacingOccurrencesOfString(API.ReturnedMapSize, withString: API.HikeMapSize)
            
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
                "overview": hikeDescription,
                "mapImageUrl": "https:" + hikeMapImageUrl,
                "kmlFileUrl": "https://" + API.APIHost + hikeKmlFileUrl,
                "gpxFileUrl": "https://" + API.APIHost + hikeGpxFileUrl
            ]
            
            completionHandlerForGetRouteById(success: true, hikeDictionary: hikeDict as? [String : AnyObject])
            
        }
    }
    
    func getAllRoutes(completionHandlerForGetAllRoutes: (success: Bool, hikeDictionaries: [[String: AnyObject]]?) -> Void) {
        
        //Since we only make this call the first time the app loads or when a user refreshes hikes,
        // get a new access token each time to ensure freshness (otherwise they expire after 60 days)
        
        getNewAccessToken { (success, accessToken) in
            
            guard success == true && accessToken != nil else {
                print("There was an error retrieving UA Access Token")
                completionHandlerForGetAllRoutes(success: false, hikeDictionaries: nil)
                return
            }
            
            var storedError: String!
            var hikeDictionaries = [[String:AnyObject]]()
            let downloadGroup = dispatch_group_create()
            
            for routeId in API.HikeRouteIds {
                //Use a dispatch group to run many async requests at once
                dispatch_group_enter(downloadGroup)
                self.getRouteById(accessToken!, routeId: routeId, completionHandlerForGetRouteById: { (success, hikeDictionary) in
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
        
    }
    
    //MARK: Access Token
    
    func getNewAccessToken(completionHandlerForGetNewAccessToken: (success: Bool, accessToken: String?) -> Void) {
        
        //Create the NSURL
        let parameters = [String: AnyObject]()
        let url = underArmourURLWithMethod(parameters, methodPath: Methods.GetAccessToken)
        
        //Set the Form Parameter String
let paramString = "\(RequestKeys.grantType)=\(RequestValues.grantType)&\(RequestKeys.clientId)=\(RequestValues.clientId)&\(RequestKeys.clientSecret)=\(RequestValues.clientSecret)"

        //Set the headers
        let headers = [HeaderKeys.APIKey: HeaderValues.APIKey]
        
        requestBuilder.taskForPOSTMethod(url, paramString: paramString, headers: headers) { (result, error) in
            
            guard error == nil else {
                print(error)
                completionHandlerForGetNewAccessToken(success: false, accessToken: nil)
                return
            }
            
            if let accessToken = result["access_token"] as? String {
                completionHandlerForGetNewAccessToken(success: true, accessToken: accessToken)
            } else {
                completionHandlerForGetNewAccessToken(success: false, accessToken: nil)
            }
            
        }
        
    }
    
    //MARK: Get Map File
    
    func downloadMapFile(url: NSURL, completionHandlerForDownloadMapFile: (success: Bool, url: NSURL?) -> Void) {
        
        getNewAccessToken { (success, accessToken) in
            
            guard success == true && accessToken != nil else {
                print("There was an error retrieving UA Access Token")
                completionHandlerForDownloadMapFile(success: false, url: nil)
                return
            }
            
            let headers = [
                HeaderKeys.APIKey: HeaderValues.APIKey,
                HeaderKeys.Authorization: "Bearer \(accessToken!)"
            ]
        
            self.requestBuilder.taskForDownload(url, headers: headers, completionHandlerForDownload:     { (url, error) in
                
                guard error == nil && url != nil else {
                    print(error)
                    completionHandlerForDownloadMapFile(success: false, url: nil)
                    return
                }
                completionHandlerForDownloadMapFile(success: true, url: url)
                
            })
            
        }
    }
    
}