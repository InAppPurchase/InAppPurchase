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
//  IAPConstants.swift
//  InAppPurchase
//
//  Created by Chris Davis on 15/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import Foundation

// MARK: Errors

internal let kIAP_Error_Domain = "com.inapppurchase.error"
internal let kIAP_Error_Code_FrameworkNotInitalized = 1
internal let kIAP_Error_Code_FrameworkNotInitalizedCorrectly = 2
internal let kIAP_Error_Code_MissingParameter = 3
internal let kIAP_Error_Code_OutOfRange = 4
internal let kIAP_Error_Code_NoDataReturned = 5

internal let frameworkNotInitalizedError = createError(kIAP_Error_Code_FrameworkNotInitalized,
    reason: Localize("iap.frameworknotinitalized.reason"),
    suggestion: Localize("iap.frameworknotinitalized.suggestion"))

// MARK: Enums

/**
 Enum for HTTP Verbs so we don't have to hard code the strings
 */
internal enum HTTPVerb : String
{
    case GET = "GET"
    case POST = "POST"
    case PATCH = "PATCH"
}

/**
 Enum for subdomain to connect to
 */
internal enum Subdomain : String
{
    case API = "api"
    case STATUS = "status"
}

// MARK: Methods

/**
 Return a NSURL for the request
 
 - parameter subdomain: The subdomain of the request
 - parameter endPoint: The endpoint
 */
internal func urlForMethod(subdomain:Subdomain, endPoint:String) -> NSURL
{
    var countryCode:String = "en-gb"
    if let code = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String
    {
        countryCode = code
    }
    return NSURL(string: "https://\(subdomain.rawValue).inapppurchase.com/v1/\(countryCode)/\(endPoint)")!
}

/**
 Log a message in debug only
 
 - parameter message: The string to log
 - parameter function: The callee function as a string
 */
internal func IAPLog(message:String, function: String = __FUNCTION__)
{
    #if !NDEBUG
        NSLog("\(function): \(message)")
    #endif
}

/**
 Error - Log regardless of debug status
 
 - parameter error: The error to log
 - parameter function: The callee function as a string
 */
internal func IAPLogError(error:NSError, function: String = __FUNCTION__)
{
    NSLog("Error: \(function): \(error.localizedDescription)")
}

/**
 Creates an NSError
 
 - parameter code: The error code
 - parameter reason: The reason for the error
 - parameter suggestion: A suggestion on how to fix the error
 
 - returns: NSError
 */
internal func createError(code:Int, reason:String, suggestion:String) -> NSError
{
    let error = NSError(domain: kIAP_Error_Domain, code: code, userInfo: [
        NSLocalizedDescriptionKey: reason,
        NSLocalizedRecoverySuggestionErrorKey: suggestion
        ])
    return error
}

/**
 Returns a localized string, a shorthand helper
 
 We must pass the bundle otherwise it uses the mainBundle
 
 - parameter key: The key in the Localizable.strings file
 - parameter parameters: Varadic list of strings
 
 - returns: String
 */
internal func Localize(key:String, parameters:String...) -> String
{
    let bundle = NSBundle(forClass: InAppPurchase.self)
    let local = NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
    return String(format: local, parameters)
}

/**
 Returns a true/false 'hint' if the device is jailbroken

 - returns: Bool
 */
internal func isJailBroken() -> Bool
{
    #if TARGET_IPHONE_SIMULATOR || os(OSX)
        return false
    #else
        let fileManager = NSFileManager.defaultManager()
        if(fileManager.fileExistsAtPath("/private/var/lib/apt"))
        {
            return true
        } else {
            return false
        }
    #endif
}


