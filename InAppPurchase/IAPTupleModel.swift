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
//  IAPTupleModel.swift
//  InAppPurchase
//
//  Created by Chris Davis on 16/12/2015.
//  Copyright © 2015 nthState. All rights reserved.
//

import Foundation

// MARK: Class

public class IAPTupleModel : IAPHydrateable
{
    // MARK: Properties
    
    var status:Int
    var statusMessage:String
    
    // MARK: Initalizers
    
    /**
    Initalizer
    */
    init()
    {
        status = -1
        statusMessage = ""
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
        if let _status = dic["status"] as? Int
        {
            status = _status
        }
        if let _statusMessage = dic["statusMessage"] as? String
        {
            statusMessage = _statusMessage
        }
    }
}
