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
//  IAPIntegrationTests.swift
//  InAppPurchase
//
//  Created by Chris Davis on 02/01/2016.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import XCTest

class IAPIntegrationTests: XCTestCase
{
    func testHydrateStatusWrongType()
    {
        // Arrange
        let iap = InAppPurchase(apiKey: "a", userId: "b")
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        _ = iap.listEntitlements { (model:IAPModel?, error:NSError?) -> () in
            
            // Assert
            XCTAssertNotNil(error, "IAP should have been initalized")
            expectation.fulfill()
        }
        
        // Async wait
        self.waitForExpectationsWithTimeout(600.0) { (error:NSError?) -> Void in
            IAPLog("\(__FUNCTION__) failed to return")
        }
    }
}
