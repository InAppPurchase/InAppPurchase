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

// MARK: Class

internal class IAPNetworkService : NSObject, NSURLSessionDelegate
{
    // MARK: Properties
    
    var apiKey:String!
    var userId:String!
    
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

        request.setValue(apiKey, forHTTPHeaderField: "apiKey")
        request.setValue(userId, forHTTPHeaderField: "userId")
        
        if let bundleId = NSBundle.mainBundle().bundleIdentifier
        {
            request.setValue(bundleId, forHTTPHeaderField: "bundleId")
        }
        if let bundleVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String
        {
            request.setValue(bundleVersion, forHTTPHeaderField: "bundleVersion")
        }
        request.setValue("\(isJailBroken())", forHTTPHeaderField: "jailBroken")
        request.setValue("\(NSProcessInfo().operatingSystemVersionString)", forHTTPHeaderField: "osVersion")
        
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
                return resp(nil, e)
            }
            
            if let returnedData = data as? NSData
            {
                do
                {
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(returnedData, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                    
                    // If there is an 'error' key
                    if
                        let jsonError = jsonDictionary["error"] as? NSDictionary,
                        let errorReason = jsonError["reason"] as? String,
                        let errorSuggestion = jsonError["suggestion"] as? String
                    {
                        let errorFromServer = createError(kIAP_Error_Code_FromServer, reason: errorReason, suggestion: errorSuggestion)
                        return resp(nil, errorFromServer)
                    }
                    
                    // Initalize the 'T' Element
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
    
    /**
     Delegate method for SSL pinning
     */
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void)
    {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
        {
            if let serverTrust = challenge.protectionSpace.serverTrust
            {
                var result:SecTrustResultType = 0
                SecTrustEvaluate(serverTrust, &result)
                
                // Read public key from server
                let remotePublicKey = SecTrustCopyPublicKey(serverTrust)
                
                // Read local public key
                let localPublicKey = "public_key"

                // TODO: Compare public key from server with local public key
                let publicKeysMatch:Bool = true
                let credential:NSURLCredential = NSURLCredential(forTrust: serverTrust)

                if publicKeysMatch
                {
                    completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
                } else {
                    completionHandler(NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge, nil)
                }
            }
        }
    }
}
