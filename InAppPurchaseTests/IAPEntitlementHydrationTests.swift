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
    
}
