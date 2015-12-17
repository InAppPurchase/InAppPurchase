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
