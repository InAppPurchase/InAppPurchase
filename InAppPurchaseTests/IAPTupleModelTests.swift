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
//  IAPTupleModelTests.swift
//  InAppPurchase
//
//  Created by Chris Davis on 16/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import XCTest

class IAPTupleModelTests: XCTestCase
{
    func testHydrateStatusWrongType()
    {
        // Arrange
        let data = [
            "status": "200"
        ]
        
        // Act
        let model = IAPTupleModel(dic: data)
        
        // Assert
        XCTAssertEqual(model.status, -1, "status should be default")
    }
    
    func testHydrateStatus()
    {
        // Arrange
        let data = [
            "status": 200
        ]
        
        // Act
        let model = IAPTupleModel(dic: data)
        
        // Assert
        XCTAssertEqual(model.status, 200, "status should be 200")
    }
    
    func testHydrateStatusMessage()
    {
        // Arrange
        let data = [
            "statusMessage": "ok"
        ]
        
        // Act
        let model = IAPTupleModel(dic: data)
        
        // Assert
        XCTAssertEqual(model.statusMessage, "ok", "statusMessage should match")
    }
}
