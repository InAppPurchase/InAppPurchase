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
//  IAPModel.swift
//  InAppPurchase
//
//  Created by Chris Davis on 15/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import Foundation

// MARK: CLass

public class IAPModel : IAPHydrateable
{
    // MARK: Properties
    
    var validReceipt:Bool
    var isPartial:Bool
    var entitlements:[IAPEntitlementModel]
    
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
