//
//  IAPHydrateable.swift
//  InAppPurchase
//
//  Created by Chris Davis on 16/12/2015.
//  Copyright © 2015 nthState. All rights reserved.
//

import Foundation

internal protocol IAPHydrateable
{
    init(dic:NSDictionary)
    func hydrate(dic:NSDictionary)
}