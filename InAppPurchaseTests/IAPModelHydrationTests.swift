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
//  IAPModelHydrationTests.swift
//  InAppPurchase
//
//  Created by Chris Davis on 16/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import XCTest

class IAPModelHydrationTests: XCTestCase
{
    func testHydrateValidReceiptWrongType()
    {
        // Arrange
        let data = [
            "validReceipt": "true"
        ]
        
        // Act
        let model = IAPModel(dic: data)
        
        // Assert
        XCTAssertFalse(model.validReceipt, "validReceipt should be false")
    }
    
    func testHydrateIsValid()
    {
        // Arrange
        let data = [
            "validReceipt": true
        ]
        
        // Act
        let model = IAPModel(dic: data)
        
        // Assert
        XCTAssertTrue(model.validReceipt, "validReceipt should be true")
    }
    
    func testHydrateIsPartial()
    {
        // Arrange
        let data = [
            "isPartial": true
        ]
        
        // Act
        let model = IAPModel(dic: data)
        
        // Assert
        XCTAssertTrue(model.isPartial, "isPartial should be true")
    }
}
