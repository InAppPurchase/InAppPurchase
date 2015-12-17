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
//  IAPResponseValidateReceiptTests.swift
//  InAppPurchase
//
//  Created by Chris Davis on 15/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import XCTest

class IAPResponseValidateReceiptTests: XCTestCase
{
    func testFrameworkNeedsToBeInitalizedBeforeValidReceiptCalled()
    {
        // Arrange
        let iap = InAppPurchase(apiKey: "", userId: "")
        iap.networkService = MockIAPNetworkService(obj: nil)
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        iap.validateReceipt { (_, error:NSError?) -> () in
            
            // Assert
            XCTAssertNotNil(error, "IAP should not have been initalized")
            expectation.fulfill()
        }
        
        // Async wait
        self.waitForExpectationsWithTimeout(0.1) { (error:NSError?) -> Void in
            IAPLog("\(__FUNCTION__) failed to return")
        }
    }
    
    func testValidReceiptReturnsTrue()
    {
        // Arrange
        let iap = InAppPurchase(apiKey: "a", userId: "b")
        let dataToReturn = "{\"validReceipt\":true}".dataUsingEncoding(NSUTF8StringEncoding)!
        let mockNetwork = MockIAPNetworkService(obj: dataToReturn)
        iap.networkService = mockNetwork
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        iap.validateReceipt { (model:IAPModel?, _) -> () in
            
            // Assert
            XCTAssertTrue(model!.validReceipt, "Receipt should be valid")
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
        iap.validateReceipt { (_, error:NSError?) -> () in
            
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
