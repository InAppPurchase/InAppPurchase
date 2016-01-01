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
//  IAPEntitlementHydrationTests.swift
//  InAppPurchase
//
//  Created by Chris Davis on 16/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import XCTest

class IAPEntitlementHydrationTests: XCTestCase
{
    func testEntitlementsHydrate()
    {
        // Arrange
        let data = [
            "entitlements": [
                [
                    "entitlementId": "1"
                ],
                [
                    "entitlementId": "2"
                ]
            ]
        ]
        
        // Act
        let model = IAPModel(dic: data)
        
        // Assert
        XCTAssertEqual(model.entitlements.count, 2, "There should be 2 entitlements")
    }
    
    func testHydrateUsed()
    {
        // Arrange
        let data = [
            "used": true
        ]
        
        // Act
        let model = IAPEntitlementModel(dic: data)
        
        // Assert
        XCTAssertTrue(model.used, "used should be true")
    }
    
    func testHydrateDateUsed()
    {
        // Arrange
        let data = [
            "dateUsed": "2011-11-02T02:50:12.208Z"
        ]
        
        // Act
        let model = IAPEntitlementModel(dic: data)
        
        // Assert
        XCTAssertNotNil(model.dateUsed, "dateUsed should not be nil")
    }
    
    func testHydrateProductId()
    {
        // Arrange
        let data = [
            "productId": "my_product"
        ]
        
        // Act
        let model = IAPEntitlementModel(dic: data)
        
        // Assert
        XCTAssertNotNil(model.productId, "productId should not be nil")
    }
    
    func testHydrateExpiryDate()
    {
        // Arrange
        let data = [
            "expiryDate": "2011-11-02T02:50:12.208Z"
        ]
        
        // Act
        let model = IAPEntitlementModel(dic: data)
        
        // Assert
        XCTAssertNotNil(model.expiryDate, "expiryDate should not be nil")
    }
    
}
