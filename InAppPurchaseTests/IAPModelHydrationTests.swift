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
