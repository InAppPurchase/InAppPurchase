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
//  IAPPaymentTransaction.swift
//  InAppPurchase
//
//  Created by Chris Davis on 15/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import Foundation
import StoreKit

// MARK: Class

internal class IAPPaymentTransaction
{
    // MARK: Methods
    
    /**
     Gets the receipt data as base 64

     - returns: A Base64 encoded string of the receipt data, if any.
     */
    internal func getReceiptDataAsBase64() -> String
    {
        let data = self.getReceiptData()
        return data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    }
    
    /**
     Gets the receipt data as NSData

     - returns: NSData of the receipt data
     */
    internal func getReceiptData() -> NSData
    {
        if
            let receiptDataURL = receiptURL(),
            let data = NSData(contentsOfURL: receiptDataURL)
        {
            return data
        }
        return NSData()
    }
    
    /**
     Gets the receipt url
     
     - returns: NSURL? to the receipt path
     */
    internal func receiptURL() -> NSURL?
    {
        return NSBundle.mainBundle().appStoreReceiptURL
    }
}
