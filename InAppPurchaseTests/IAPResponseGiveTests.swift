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
//  IAPResponseNonConsumableTests.swift
//  InAppPurchase
//
//  Created by Chris Davis on 15/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import XCTest

class IAPResponseGiveTests: XCTestCase
{
    func testFrameworkNeedsToBeInitalizedBeforeUseNonConsumableCalled()
    {
        // Arrange
        let iap = InAppPurchase(apiKey: "", userId: "")
        iap.networkService = MockIAPNetworkService(obj: nil)
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        iap.give("a") { (_, error:NSError?) -> () in
            
            // Assert
            XCTAssertNotNil(error, "IAP should not have been initalized")
            expectation.fulfill()
        }
        
        // Async wait
        self.waitForExpectationsWithTimeout(0.1) { (error:NSError?) -> Void in
            IAPLog("\(__FUNCTION__) failed to return")
        }
    }
    
    func testProductIdRequired()
    {
        // Arrange
        let iap = InAppPurchase(apiKey: "a", userId: "b")
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        iap.give("") { (_, error:NSError?) -> () in
            
            // Assert
            XCTAssertNotNil(error, "We should have an error")
            expectation.fulfill()
        }
        
        // Async wait
        self.waitForExpectationsWithTimeout(0.1) { (error:NSError?) -> Void in
            IAPLog("\(__FUNCTION__) failed to return")
        }
    }
    
    func testBadDataReturnsError()
    {
        // Arrange
        let iap = InAppPurchase(apiKey: "a", userId: "b")
        let dataToReturn = "{\"garbage\":".dataUsingEncoding(NSUTF8StringEncoding)!
        let mockNetwork = MockIAPNetworkService(obj: dataToReturn)
        iap.networkService = mockNetwork
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        iap.give("a") { (_, error:NSError?) -> () in
            
            // Assert
            XCTAssertNotNil(error, "Should have an error")
            expectation.fulfill()
        }
        
        // Async wait
        self.waitForExpectationsWithTimeout(0.1) { (error:NSError?) -> Void in
            IAPLog("\(__FUNCTION__) failed to return")
        }
    }

}
