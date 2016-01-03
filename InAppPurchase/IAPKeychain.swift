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
//  IAPKeychain.swift
//  InAppPurchase
//
//  Created by Chris Davis on 02/01/2016.
//  Email: contact@inapppurchase.com
//  Copyright © 2015 nthState. All rights reserved.
//

import Foundation

// MARK: Class

internal class IAPKeychain
{
    // MARK: Properties
    
    let applicationTag:String = "com.inapppurchase.v1.temp"
    
    // MARK: Methods
    
    /**
    A method to convert a SecKey's public key to a string
    
    If there is a better/easier/more elegant way to do this, please let me know.
    
    - parameter inputKey: The key to extract the public key from
    - returns: String?
    */
    internal func secKeyPublicKeyToString(inputKey: SecKey) -> String?
    {
        var output:String?
        
        if add(inputKey) == false
        {
            delete()
        }
        if let result = get()
        {
            output = result.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        }
        delete()
        
        return output
    }
    
    /**
     Add an item to the keychain

     - parameter obj: AnyObject
     - returns: Bool
     */
    internal func add(obj:AnyObject) -> Bool
    {
        let parameters = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: applicationTag,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecValueRef as String: obj,
            kSecReturnData as String: kCFBooleanTrue
        ]
        
        let status:OSStatus = SecItemAdd(parameters as CFDictionaryRef, nil)

        return status == noErr
    }
    
    /**
     Get just added item from the keychain
     
     - returns: NSData?
     */
    internal func get() -> NSData?
    {
        let parameters = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: applicationTag,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimitOne as String: true
        ]
        
        var returnData:NSData?
        var dataTypeRef:AnyObject?
        let lastResultCode = withUnsafeMutablePointer(&dataTypeRef) {
            SecItemCopyMatching(parameters, UnsafeMutablePointer($0))
        }
        
        if lastResultCode == noErr
        {
            returnData = dataTypeRef as? NSData
        }
        
        return returnData
    }
    
    /**
     Delete just added item from the keychain
     
     - returns: Bool
     */
    internal func delete() -> Bool
    {
        let parameters = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: applicationTag
        ]
        
        let status:OSStatus = SecItemDelete(parameters)
        
        return status == noErr
    }
}
