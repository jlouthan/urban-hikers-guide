//
//  UnderArmourConstants.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 10/1/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

extension UnderArmourClient {
    
    struct API {
        //MARK: URLs
        static let APIScheme = "https"
        static let APIHost = "oauth2-api.mapmyapi.com"
        static let APIPath = "/v7.1"
        //MARK: Common Headers
        static let CommonHeaders = [
            HeaderKeys.APIKey: HeaderValues.APIKey,
            HeaderKeys.Authorization: HeaderValues.Authorization
        ]
        //MARK: Hike Route IDs
        // IDs of the routes used for hikes in the app
        //TODO load this from a plist?
        static let HikeRouteIds = [
            "1294135363",
            "1294139323",
            "1296367525"
        ]
    }
    
    //MARK: Header Keys {
    struct HeaderKeys {
        static let APIKey = "Api-Key"
        static let Authorization = "Authorization"
    }
    
    //MARK: Header Values {
    struct HeaderValues {
        static let APIKey = "tmsv3uyh462u7fwqawhwy8stzdqsdzfs"
        //TODO allow for overwriting this access token after the 60 day TTL
        static let Authorization = "Bearer 9fed1f01e0148dec037e751e2f4ebe7f57d929bc"
    }
    
    //MARK: Methods
    struct Methods {
        static let RouteById = "/route/{routeId}"
        //TODO add refresh method here
    }
    
    //MARK: URL Keys
    struct URLKeys {
        static let RouteId = "routeId"
    }
    
    //MARK: Parameter Keys
    struct ParameterKeys {
        static let fieldSet = "field_set"
    }
    
    //MARK: Parameter Values
    struct ParameterValues {
        static let fieldSet = "detailed"
    }
    
    //MARK: Response Keys
    struct ResponseKeys {
        static let HikeName = "name"
        static let HikeDistance = "distance"
        static let HikeDescription = "description"
        static let HikeLinkes = "_links"
        //MARK: Response links keys
        static let HikeMapUrl = "_links.thumbnail.0.href"
        static let HikeKmlUrl = "_linkes.alternate.0.href"
        static let HikeGpxUrl = "_links.alternate.1.href"
    }
}
