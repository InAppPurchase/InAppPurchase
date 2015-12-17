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
//  MockIAPPaymentTransaction.swift
//  InAppPurchase
//
//  Created by Chris Davis on 15/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import Foundation

// MARK: Class

class MockIAPPaymentTransaction : IAPPaymentTransaction
{
    // MARK: Properties
    
    var urlToReturn:NSURL?
    
    // MARK: Initalizer
    
    init(url:NSURL?)
    {
        self.urlToReturn = url
    }
    
    // MARK: Methods
    
    override func receiptURL() -> NSURL?
    {
        return self.urlToReturn
    }
}
