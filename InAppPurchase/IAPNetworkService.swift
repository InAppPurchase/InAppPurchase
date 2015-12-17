//  The MIT License (MIT)
//  
//  Copyright (c) 2015 Chris Davis
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//  
//  THMNetworkService.swift
//  iTheme
//
//  Created by Chris Davis on 17/08/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import Foundation

// MARK: Block Definitions

/**
 Type definitions for block response
 */
internal typealias NetworkResponse = (NSURLRequest?, NSHTTPURLResponse?, AnyObject?, NSError?) -> ()
//internal typealias JSONResponse = (IAPModel?, NSError?) -> ()
//internal typealias JSONResponse = (Element, NSError?) -> ()

// MARK: Class

internal class IAPNetworkService
{
    // MARK: Methods
    
    /**
    A standard wrapper for HTTP calls
    
    - parameter newUrl: url to call
    - parameter method: HTTP method
    - parameter parameters: Optional parameters
    - parameter response: The response block
    */
    internal func buildRequest(url:NSURL, method:HTTPVerb, parameters:[NSObject:AnyObject]?) -> NSMutableURLRequest
    {
        var jsonBodyAsData:NSData?
        if let p = parameters
        {
            do {
                jsonBodyAsData = try NSJSONSerialization.dataWithJSONObject(p, options: NSJSONWritingOptions(rawValue: 0))
            } catch let error as NSError
            {
                IAPLogError(error)
            }
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method.rawValue
        request.HTTPBody = jsonBodyAsData
        request.setValue(NSDate.currentDateToTimeZoneString(), forHTTPHeaderField: "timeStamp")
        
        if let bundleId = NSBundle.mainBundle().bundleIdentifier
        {
            request.setValue(bundleId, forHTTPHeaderField: "bundleId")
        }
        if let bundleVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String
        {
            request.setValue(bundleVersion, forHTTPHeaderField: "bundleVersion")
        }
        request.setValue("\(isJailBroken())", forHTTPHeaderField: "jailBroken")
        
        #if os(iOS)
            request.setValue("iOS", forHTTPHeaderField: "platform")
        #elseif os(watchOS)
            request.setValue("watchOS", forHTTPHeaderField: "platform")
        #elseif os(tvOS)
            request.setValue("tvOS", forHTTPHeaderField: "platform")
        #elseif os(OSX)
            request.setValue("OSX", forHTTPHeaderField: "platform")
        #else
            request.setValue("unknown", forHTTPHeaderField: "platform")
        #endif

        return request
    }
    
    /**
     A standard wrapper for HTTP calls
     
     - parameter newUrl: url to call
     - parameter method: HTTP method
     - parameter parameters: Optional parameters
     - parameter response: The response block
     */
    internal func standard(request:NSURLRequest, response resp:NetworkResponse)
    {
        NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            resp(request, response as? NSHTTPURLResponse, data, error)
            }.resume()
    }
    
    /**
     A method to call JSON endpoints and return the deserialzed JSON String into a Dictionary
     
     - parameter newUrl: url to call
     - parameter method: HTTP method
     - parameter parameters: Optional parameters
     - parameter response: The response block
     */
    internal func json<T:IAPHydrateable>(url:NSURL, method:HTTPVerb, parameters:[NSObject:AnyObject]?, response resp:(T?, NSError?) -> ())
    {
        let request = buildRequest(url, method: method, parameters: parameters)
        standard(request) { (request:NSURLRequest?, httpResponse:NSHTTPURLResponse?, data:AnyObject?, error:NSError?) -> () in
            
            if let e = error
            {
                IAPLogError(e)
                resp(nil, error)
            } else {
                if let returnedData = data as? NSData
                {
                    do
                    {
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(returnedData, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                        
                        if
                            let jsonError = jsonDictionary["error"] as? NSDictionary,
                            let erroCode = jsonError["errorCode"] as? Int,
                            let errorReason = jsonError["errorReason"] as? String,
                            let errorSuggestion = jsonError["errorSuggestion"] as? String
                        {
                            let errorFromServer = createError(erroCode, reason: errorReason, suggestion: errorSuggestion)
                            return resp(nil, errorFromServer)
                        }
                        
                        let model = T(dic: jsonDictionary)
                        resp(model, error)
                        
                    } catch let error as NSError
                    {
                        IAPLogError(error)
                        resp(nil, error)
                    }
                } else {
                    let noDataError = createError(kIAP_Error_Code_NoDataReturned,
                        reason: Localize("iap.apinodata.reason"),
                        suggestion: Localize("iap.apinodata.suggestion"))
                    
                    resp(nil, noDataError)
                }
            }
        }
    }
}
