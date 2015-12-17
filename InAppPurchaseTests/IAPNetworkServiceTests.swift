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
    
    func testJSONReturnsErrorValue()
    {
        // Arrange
        let dataToReturn = "{\"error\": {\"code\": 1,\"reason\": \"myReasson\",\"suggestion\": \"mySuggestion\"}}".dataUsingEncoding(NSUTF8StringEncoding)!
        let mockService = MockIAPNetworkService(obj: dataToReturn)
        
        let expectation = self.expectationWithDescription(__FUNCTION__)
        
        // Act
        mockService.json(NSURL(), method:.POST, parameters: nil) { (model:IAPModel?, error:NSError?) -> () in
            
            // Assert
            XCTAssertEqual(error!.localizedRecoverySuggestion, "mySuggestion", "Error suggestion should match")
            expectation.fulfill()
        }
        
        // Async wait
        self.waitForExpectationsWithTimeout(0.1) { (error:NSError?) -> Void in
            IAPLog("\(__FUNCTION__) failed to return")
        }
    }
}
