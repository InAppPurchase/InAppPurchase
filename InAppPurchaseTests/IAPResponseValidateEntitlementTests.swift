//
//  IAPResponseValidateEntitlementTests.swift
//  InAppPurchase
//
//  Created by Chris Davis on 17/12/2015.
//  Copyright © 2015 nthState. All rights reserved.
//

import XCTest

class IAPResponseValidateEntitlementTests: XCTestCase
{
    func testFrameworkNeedsToBeInitalizedBeforeValidateEntitlementCalled()
    {
        // Arrange
        let iap = InAppPurchase(apiKey: "", userId: "")
        iap.networkService = MockIAPNetworkService(obj: nil)
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        iap.validateEntitlement("a") { (_, error:NSError?) -> () in
            
            // Assert
            XCTAssertNotNil(error, "IAP should not have been initalized")
            expectation.fulfill()
        }
        
        // Async wait
        self.waitForExpectationsWithTimeout(0.1) { (error:NSError?) -> Void in
            IAPLog("\(__FUNCTION__) failed to return")
        }
    }

    func testEntitlementIdRequired()
    {
        // Arrange
        let iap = InAppPurchase(apiKey: "a", userId: "b")
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        iap.validateEntitlement("") { (_, error:NSError?) -> () in
            
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
        iap.validateEntitlement("a") { (_, error:NSError?) -> () in
            
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
