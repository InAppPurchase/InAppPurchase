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
