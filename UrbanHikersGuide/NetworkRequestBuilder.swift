//
//  NetworkRequestBuilder.swift
//  UrbanHikersGuide
//
//  Created by Jennifer Louthan on 10/1/16.
//  Copyright © 2016 JennyLouthan. All rights reserved.
//

import Foundation

class NetworkRequestBuilder: NSObject {
    
    var session = NSURLSession.sharedSession()
    
    //MARK: Data Tasks
    
    //MARK: Generic GET Request
    func taskForGETMethod (url: NSURL, headers: [String: String], completionHandlerForGET: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
        //Accepting a ready-build url, so we start here
        let request = NSMutableURLRequest(URL: url)
        //Add any headers
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        //Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(errorString: String) {
                completionHandlerForGET(result: nil, error: errorString)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(self.getStringFromError(error!))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: { (result, error) in
                    let errorString: String
                    if let errorDict = result as? [String: AnyObject] {
                        errorString = errorDict["error"] as! String
                    } else {
                        errorString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                    }
                    sendError(errorString)
                    return
                })
                return
            }
            
            //Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        //Start the request
        task.resume()
        
        return task
    }
    
    // MARK: Generic POST request, uses x-www-form-urlencoded
    
    func taskForPOSTMethod (url: NSURL, paramString: String, headers: [String: String], completionHandlerForPOST: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
        let postData = paramString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let postLength = String(format: "%d", postData!.length)
        
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
    
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        //Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(errorString: String) {
                completionHandlerForPOST(result: nil, error: errorString)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(self.getStringFromError(error!))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: { (result, error) in
                    let errorString: String
                    if let errorDict = result as? [String: AnyObject] {
                        errorString = errorDict["error"] as! String
                    } else {
                        errorString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                    }
                    sendError(errorString)
                    return
                })
                return
            }
            
            //Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        //Start the request
        task.resume()
        
        return task
        
    }
    
    //Generic download task
    func taskForDownload(url: NSURL, headers: [String: String], completionHandlerForDownload: (url: NSURL?, error: String?) -> Void) -> NSURLSessionDownloadTask {
        
        
        let request = NSMutableURLRequest(URL: url)
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let task = session.downloadTaskWithRequest(request) { (url, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completionHandlerForDownload(url: nil, error: self.getStringFromError(error!))
                return
            }
            
            guard let url = url else {
                completionHandlerForDownload(url: nil, error: "No url returned from download request")
                return
            }
            
            completionHandlerForDownload(url: url, error: nil)
            
        }
        
        //Start the request
        task.resume()
        return task
    }
    
    
    //MARK: Helpers
    private func getStringFromError(error: NSError) -> String {
        var errorText: String
        if let errorDict = error.userInfo[NSLocalizedDescriptionKey] as? [String: AnyObject] {
            errorText = errorDict["error"] as! String
        } else {
            errorText = error.userInfo[NSLocalizedDescriptionKey] as! String
        }
        return errorText
    }
    
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: String?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            completionHandlerForConvertData(result: parsedResult, error: nil)
        } catch {
            completionHandlerForConvertData(result: nil, error: "Could not parse the data as JSON: '\(data)'")
        }
    }
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    //MARK: Shared Instance
    class func sharedInstance() -> NetworkRequestBuilder {
        struct Singleton {
            static var sharedInstance = NetworkRequestBuilder()
        }
        return Singleton.sharedInstance
    }
    
}