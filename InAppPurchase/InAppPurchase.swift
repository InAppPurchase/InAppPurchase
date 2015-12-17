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
//  InAppPurchase.swift
//  InAppPurchase
//
//  Created by Chris Davis on 15/12/2015.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import Foundation
import StoreKit

// MARK: Block Definitions

/**
 Type definitions for block response
 */
public typealias IAPDataResponse = (IAPModel?, NSError?) -> ()

// MARK: Class

public class InAppPurchase
{
    // MARK: Properties
    
    internal var networkService:IAPNetworkService   // The networking service, for HTTP calls
    internal var isInitalized:Bool?                 // Has the framework been initalized
    public private(set) var apiKey:String!          // ApiKey per app
    public private(set) var userId:String!          // UserId for association
    
    // MARK: Initalizers
    
    /**
     Shared Instance 
     
     Singleton
     */
    public class var sharedInstance: InAppPurchase {
        struct Static {
            static var instance: InAppPurchase?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = InAppPurchase()
        }
        
        return Static.instance!
    }
    
    /**
     Initalizer.
     
     Initalizes the network service
     */
    private init()
    {
        networkService = IAPNetworkService()
    }
    
    /**
     Convenience Initalizer.
     */
    public convenience init(apiKey:String, userId:String)
    {
        self.init()
        self.Initalize(apiKey, userId: userId)
    }
    
    /**
     Initalize the framework with the correct keys
     
     - parameter apiKey: Api Key for the app
     - parameter userId: User Id for association
     */
    public func Initalize(apiKey:String, userId:String)
    {
        if
            apiKey.isEmpty ||
            userId.isEmpty
        {
            let error = createError(kIAP_Error_Code_FrameworkNotInitalizedCorrectly,
                reason: Localize("iap.apikeyuserkeyempty.reason"),
                suggestion: Localize("iap.apikeyuserkeyempty.suggestion"))
            
            IAPLogError(error)
            return
        }
        
        self.apiKey = apiKey
        self.userId = userId
        self.isInitalized = true
    }
    
    // MARK: Actions
    
    /**
     Validates the receipt stored on disk
    
    Does NOT save receipt to the API
     
     - parameter response: The block which is called asynchronously with the result
     */
    public func validateReceipt(response:IAPDataResponse)
    {
        // Check framework has been initalized
        guard let _ = self.isInitalized else {
            let error = frameworkNotInitalizedError
            IAPLogError(error)
            return response(nil, error)
        }

        // Gather Data
        let parameters:[NSObject:AnyObject] = [
            "receiptData": self.getPaymentData()
        ]
        
        // Send Data
        networkService.json(urlForMethod(.API, endPoint: "sdk/receipt/validate"), method: .POST, parameters: parameters) { (model:IAPModel?, error:NSError?) -> () in
            
            response(model, error)
        }
    }
    
    /**
     Saves the receipt stored on disk to the API
    
     Uploads the receipt to server.
     Processes receipt as per productId|data match,
     Creates entitlements

     - parameter response: The block which is called asynchronously with the result
     */
    public func saveReceipt(response:IAPDataResponse)
    {
        // Check framework has been initalized
        guard let _ = self.isInitalized else {
            let error = frameworkNotInitalizedError
            IAPLogError(error)
            return response(nil, error)
        }

        // Gather Data
        let parameters:[NSObject:AnyObject] = [
            "receiptData": self.getPaymentData()
        ]
        
        // Send Data
        networkService.json(urlForMethod(.API, endPoint: "sdk/receipt/save"), method: .POST, parameters: parameters) { (model:IAPModel?, error:NSError?) -> () in

            response(model, error)
        }
    }
    
    /**
     Use a Consumable item
     
     handlePartial? - I want to use 6, but only have 4 left.
     - [entitlementId] - Unique id for each scalar item
     
     error:
     - product Id does not exist
     - no items left to use.
     
     - parameter response: The block which is called asynchronously with the result
     */
    public func useConsumable(productId:String, scalar:Int?, response:IAPDataResponse)
    {
        // Check framework has been initalized
        guard let _ = self.isInitalized else {
            let error = frameworkNotInitalizedError
            IAPLogError(error)
            return response(nil, error)
        }
        
        // Validate Input
        if productId.isEmpty
        {
            let error = createError(kIAP_Error_Code_MissingParameter,
                reason: Localize("iap.parameterrequired.reason", parameters: "productId"),
                suggestion: Localize("iap.parameterrequired.suggestion", parameters: "productId"))
            
            IAPLogError(error)
            return response(nil, error)
        }
        
        // Gather Data
        var parameters:[NSObject:AnyObject] = [
            "receiptData": self.getPaymentData(),
            "productId": productId
        ]
        
        if
            let _scalar = scalar
        {
            if _scalar < 0
            {
                let error = createError(kIAP_Error_Code_OutOfRange,
                    reason: Localize("iap.parameteroutofrange.reason", parameters: "scalar"),
                    suggestion: Localize("iap.parameteroutofrange.suggestion", parameters: "scalar"))
                
                IAPLogError(error)
                return response(nil, error)
            } else {
                parameters["scalar"] = _scalar
            }
        }

        
        
        // Send Data
        networkService.json(urlForMethod(.API, endPoint: "sdk/receipt/use"), method: .PATCH, parameters: parameters) { (model:IAPModel?, error:NSError?) -> () in
            
            response(model, error)
        }
    }
    
    /**
     Validates the receipt stored on disk
     
     - parameter response: The block which is called asynchronously with the result
     */
    public func useNonConsumable(productId:String, response:IAPDataResponse)
    {
        // Check framework has been initalized
        guard let _ = self.isInitalized else {
            let error = frameworkNotInitalizedError
            IAPLogError(error)
            return response(nil, error)
        }
        
        // Validate Input
        if productId.isEmpty
        {
            let error = createError(kIAP_Error_Code_MissingParameter,
                reason: Localize("iap.parameterrequired.reason", parameters: "productId"),
                suggestion: Localize("iap.parameterrequired.suggestion", parameters: "productId"))
            
            IAPLogError(error)
            return response(nil, error)
        }
        
        // Gather Data
        let parameters:[NSObject:AnyObject] = [
            "receiptData": self.getPaymentData(),
            "productId": productId
        ]
        
        // Send Data
        networkService.json(urlForMethod(.API, endPoint: "sdk/product/use"), method: .PATCH, parameters: parameters) { (model:IAPModel?, error:NSError?) -> () in
            
            response(model, error)
        }
    }
    
    /**
     Return all entitlements for a user
     
     [
     {
     "entitlementId": "sdfsdfds",
     "used": true|false
     "dateUsed": nil|date,
     "productId": "egertb",
     "purchaseTransactionId": "345gerfs"
     },...
     ]
     
     - parameter response: The block which is called asynchronously with the result
     */
    public func listEntitlements(response:IAPDataResponse)
    {
        // Check framework has been initalized
        guard let _ = self.isInitalized else {
            let error = frameworkNotInitalizedError
            IAPLogError(error)
            return response(nil, error)
        }

        // Send Data
        networkService.json(urlForMethod(.API, endPoint: "sdk/entitlements/list"), method: .POST, parameters: nil) { (model:IAPModel?, error:NSError?) -> () in
            
            response(model, error)
        }
    }

    /**
     Has a specific entitlement been used?,
     
     - parameter response: The block which is called asynchronously with the result
     */
    public func validateEntitlement(entitlementId:String, response:IAPDataResponse)
    {
        // Check framework has been initalized
        guard let _ = self.isInitalized else {
            let error = frameworkNotInitalizedError
            IAPLogError(error)
            return response(nil, error)
        }
        
        // Validate Input
        if entitlementId.isEmpty
        {
            let error = createError(kIAP_Error_Code_MissingParameter,
                reason: Localize("iap.parameterrequired.reason", parameters: "entitlementId"),
                suggestion: Localize("iap.parameterrequired.suggestion", parameters: "entitlementId"))
            
            IAPLogError(error)
            return response(nil, error)
        }
        
        // Gather Data
        let parameters:[NSObject:AnyObject] = [
            "receiptData": self.getPaymentData(),
            "entitlementId": entitlementId
        ]
        
        // Send Data
        networkService.json(urlForMethod(.API, endPoint: "sdk/entitlement/validate"), method: .GET, parameters: parameters) { (model:IAPModel?, error:NSError?) -> () in
            
            response(model, error)
        }
    }

    /**
     Checks the status of the api
     
     - parameter response: The block which is called asynchronously with the result
     */
    public func status(response:(Bool, IAPTupleModel?, NSError?) -> ())
    {
        // Send Data
        networkService.json(urlForMethod(.STATUS, endPoint: "status"), method: .GET, parameters: nil) { (model:IAPTupleModel?, error:NSError?) -> () in
            
            var running:Bool = false
            if let isRunning = model?.status
                where isRunning == 200
            {
                running = true
            }
            response(running, model, error)
        }
    }
    
    // MARK: Helpers
    
    /**
     Gets the payment data as a string
    
    - returns: String
     */
    private func getPaymentData() -> String
    {
        let paymentDetails = IAPPaymentTransaction()
        return paymentDetails.getReceiptDataAsBase64()
    }
    
}
