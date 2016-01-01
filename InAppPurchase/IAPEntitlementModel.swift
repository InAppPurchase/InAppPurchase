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
//  IAPEntitlementModel.swift
//  InAppPurchase
//
//  Created by Chris Davis on 15/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import Foundation

// MARK: Class

public class IAPEntitlementModel : IAPHydrateable, CustomDebugStringConvertible
{
    // MARK: Properties
    
    public var entitlementId:String!
    public var used:Bool
    public var dateUsed:NSDate?
    public var expiryDate:NSDate?
    public var productId:String!
    
    public var debugDescription: String {
        return "entitlementId: \(entitlementId), used: \(used), productId: \(productId), dateUsed: \(dateUsed), expiryDate: \(expiryDate)"
    }
    
    // MARK: Initalizers
    
    /**
     Initalizer
     */
    init()
    {
        used = false
    }
    
    /**
     Initalizer with hydration
     
     - parameter dic: The dictionary of values
     */
    convenience required public init(dic:NSDictionary)
    {
        self.init()
        hydrate(dic)
    }
    
    // MARK: Hydration
    
    /**
     Hydrate the object
     
     - parameter dic: The dictionary of values
     */
    func hydrate(dic:NSDictionary)
    {
        if let _entitlementId = dic["entitlementId"] as? String
        {
            entitlementId = _entitlementId
        }
        if let _used = dic["used"] as? Bool
        {
            used = _used
        }
        if
            let _dateUsed = dic["dateUsed"] as? String,
            let _converted = NSDate.dateToTimeZoneString(_dateUsed)
        {
            dateUsed = _converted
        }
        if let _productId = dic["productId"] as? String
        {
            productId = _productId
        }
        if
            let _expiryDate = dic["expiryDate"] as? String,
            let _converted = NSDate.dateToTimeZoneString(_expiryDate)
        {
            expiryDate = _converted
        }
    }
}
