//  Copyright (C) 2015 Chris Davis
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
