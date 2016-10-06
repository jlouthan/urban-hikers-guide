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
        static let APIHost = "api.ua.com"
        static let APIPath = "/v7.1"
        //MARK: Hike Route IDs
        // IDs of the routes used for hikes in the app
        //TODO load this from a plist?
        static let HikeRouteIds = [
            "1294135363",
            "1294139323",
            "1296367525",
            "1302828913",
            "1302842473",
            "1302860908",
            "1302869728",
            "1302875917",
            "1302883867",
            "1302891301",
            "1302899122",
            "1302909400"
        ]
        //Ensure we retrieve a large enough map from Cloudfront
        static let ReturnedMapSize = "100"
        static let HikeMapSize = "600"
    }
    
    //MARK: Header Keys {
    struct HeaderKeys {
        static let APIKey = "Api-Key"
        static let Authorization = "Authorization"
    }
    
    //MARK: Header Values {
    struct HeaderValues {
        static let APIKey = "tmsv3uyh462u7fwqawhwy8stzdqsdzfs"
    }
    
    //MARK: Methods
    struct Methods {
        static let RouteById = "/route/{routeId}"
        static let GetAccessToken = "/oauth2/access_token/"
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
    
    //MARK: Request Keys
    struct RequestKeys {
        static let grantType = "grant_type"
        static let clientId = "client_id"
        static let clientSecret = "client_secret"
    }
    
    //MARK: Request Values
    struct RequestValues {
        static let grantType = "client_credentials"
        static let clientId = "tmsv3uyh462u7fwqawhwy8stzdqsdzfs"
        static let clientSecret = "tuJpw9Sap2xD3XuJaAn2asMKMAX45snjCqEjw59YwB7"
    }
    
    //MARK: Response Keys
    struct ResponseKeys {
        static let HikeName = "name"
        static let HikeDistance = "distance"
        static let HikeDescription = "description"
        static let HikeLinks = "_links"
        //MARK: Response links locations
        static let HikeMapUrlPath = ["thumbnail", 0, "href"]
        static let HikeKmlUrlPath = ["alternate", 0, "href"]
        static let HikeGpxUrlPath = ["alternate", 1, "href"]
    }
}
