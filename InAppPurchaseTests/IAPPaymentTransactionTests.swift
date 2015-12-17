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
//  IAPPaymentTransactionTests.swift
//  InAppPurchase
//
//  Created by Chris Davis on 17/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import XCTest

class IAPPaymentTransactionTests: XCTestCase
{
    var tempURL:NSURL!
    
    override func setUp()
    {
        super.setUp()
        
        let fileContents = "fake receipt data"
        let fileNameWithGuid = String(format: "%@_%@", NSProcessInfo.processInfo().globallyUniqueString, "file.dat")
        tempURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(fileNameWithGuid)
        
        do
        {
            try fileContents.writeToURL(tempURL, atomically: true, encoding: NSUTF8StringEncoding)
        } catch let error as NSError
        {
            IAPLogError(error)
        }
    }
    
    override func tearDown()
    {
        do {
            try NSFileManager.defaultManager().removeItemAtURL(tempURL)
        } catch let error as NSError {
            IAPLogError(error)
        }

        super.tearDown()
    }
    
    func testNoReceiptReturnsBaseNSData()
    {
        // Arrange
        let paymentTransaction = MockIAPPaymentTransaction(url: nil)
        
        // Act
        let data = paymentTransaction.getReceiptDataAsBase64()
        
        // Assert
        XCTAssertEqual(data, "", "No receipt should yield an empty string")
    }
    
    func testReceiptReturnsNonEmptyString()
    {
        // Arrange
        let paymentTransaction = MockIAPPaymentTransaction(url: tempURL)
        
        // Act
        let data = paymentTransaction.getReceiptDataAsBase64()
        
        // Assert
        XCTAssertEqual(data, "ZmFrZSByZWNlaXB0IGRhdGE=", "No receipt should not yield an empty string")
    }
}
