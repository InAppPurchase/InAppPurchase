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
//  IAPNetworkServiceTests.swift
//  InAppPurchase
//
//  Created by Chris Davis on 15/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import XCTest

class IAPNetworkServiceTests: XCTestCase
{
    func testBadJSONIsUnparseable()
    {
        // Arrange
        let dataToReturn = "{'data':'...".dataUsingEncoding(NSUTF8StringEncoding)!
        let mockService = MockIAPNetworkService(obj: dataToReturn)
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        mockService.json(NSURL(), method:.POST, parameters: nil) { (model:IAPModel?, error:NSError?) -> () in
            
            // Assert
            XCTAssertNotNil(error, "JSON parsing should have failed")
            expectation.fulfill()
        }
        
        // Async wait
        self.waitForExpectationsWithTimeout(0.1) { (error:NSError?) -> Void in
            IAPLog("\(__FUNCTION__) failed to return")
        }
    }
    
    func testJSONIsParseable()
    {
        // Arrange
        let dataToReturn = "{\"data\": \"\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        let mockService = MockIAPNetworkService(obj: dataToReturn)
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        mockService.json(NSURL(), method:.POST, parameters: nil) { (model:IAPModel?, error:NSError?) -> () in
            
            // Assert
            XCTAssertNil(error, "JSON parsing should be ok")
            expectation.fulfill()
        }
        
        // Async wait
        self.waitForExpectationsWithTimeout(0.1) { (error:NSError?) -> Void in
            IAPLog("\(__FUNCTION__) failed to return")
        }
    }
    
    func testBadResponseReturnsError()
    {
        // Arrange
        let errorToReturn = NSError(domain: kIAP_Error_Domain, code: 403, userInfo: nil)
        let mockService = MockIAPNetworkService(obj: nil, error: errorToReturn)
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        mockService.json(NSURL(), method:.POST, parameters: nil) { (model:IAPModel?, error:NSError?) -> () in
            
            // Assert
            XCTAssertNotNil(error, "Error should be returned")
            expectation.fulfill()
        }
        
        // Async wait
        self.waitForExpectationsWithTimeout(0.1) { (error:NSError?) -> Void in
            IAPLog("\(__FUNCTION__) failed to return")
        }
    }
    
    func testEmptyResponseIsError()
    {
        // Arrange
        let mockService = MockIAPNetworkService(obj: nil)
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        mockService.json(NSURL(), method:.POST, parameters: nil) { (model:IAPModel?, error:NSError?) -> () in
            
            // Assert
            XCTAssertNotNil(error, "No Response should cause an error")
            expectation.fulfill()
        }
        
        // Async wait
        self.waitForExpectationsWithTimeout(0.1) { (error:NSError?) -> Void in
            IAPLog("\(__FUNCTION__) failed to return")
        }
    }
}
