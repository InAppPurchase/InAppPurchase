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
//  IAPModel.swift
//  InAppPurchase
//
//  Created by Chris Davis on 15/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import Foundation

// MARK: Class

public class IAPModel : IAPHydrateable, CustomDebugStringConvertible
{
    // MARK: Properties
    
    public var validReceipt:Bool
    public var isPartial:Bool
    public var entitlements:[IAPEntitlementModel]
    
    public var debugDescription: String {
        var output = "IAPModel: \n" +
        "validReceipt: \(validReceipt)\n" +
        "isPartial: \(isPartial)\n" +
        "entitlements:\n"
        for entitlement in entitlements
        {
            output += "\t \(entitlement)\n"
        }
        return output
    }
    
    // MARK: Initalizers
    
    /**
     Initalizer
     */
    init()
    {
        validReceipt = false
        isPartial = false
        entitlements = [IAPEntitlementModel]()
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
        if let _validReceipt = dic["validReceipt"] as? Bool
        {
            validReceipt = _validReceipt
        }
        if let _isPartial = dic["isPartial"] as? Bool
        {
            isPartial = _isPartial
        }
        if let _entitlements = dic["entitlements"] as? NSArray
        {
            entitlements = _entitlements.flatMap() { IAPEntitlementModel(dic: $0 as! NSDictionary) }
        }
    }
}
