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
//  IAPEntitlementModel.swift
//  InAppPurchase
//
//  Created by Chris Davis on 15/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import Foundation

// MARK: Class

class IAPEntitlementModel : IAPHydrateable
{
    // MARK: Properties
    
    var entitlementId:String!
    var used:Bool
    var dateUsed:NSDate?
    var productId:String!
    
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
    convenience required init(dic:NSDictionary)
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
    }
}
