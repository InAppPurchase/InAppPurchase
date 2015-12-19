# InAppPurchase

The InAppPurchase framework is a supplementary framework to Apple's own StoreKit.

If allows you to very easily manage consumables and non-consumables without needing
to write your own web based system. We handle that for you.

We validate receipts and provide a management system for consumables/non-comsumables 
to your customers.

For example: You can set up a consumable item of 10 apples. You can use 3 apples and 
be left with 7. The service even allows you to top up and request how many apples
you have left.


```swift
import InAppPurchase
```


```
use_frameworks!

pod 'InAppPurchase', :git => 'https://github.com/InAppPurchase/InAppPurchase.git'
```

## Initalizers

```swift
let iap = InAppPurchase(apiKey: "myKey", userId: "userId")
```

*Optional*: Use a singleton

```swift
InAppPurchase.sharedInstance.Initalize(apiKey: "myKey", userId: "userId")
```

## Validation

```swift
iap.validateReceipt { (model:IAPModel?, error:NSError?) -> () in

}
```

## Save

```swift
iap.saveReceipt { (model:IAPModel?, error:NSError?) -> () in

}
```

## Consumable

User has purchased a consumable with a scalar quantity of 10, and the user will use 3
of them.

```swift
iap.useConsumable("com.my.consumable", scalar: 3) { (model:IAPModel?, error:NSError?) -> () in

}
```

The user then only has 7 uses left.

*Optional*: If the app is configured to fulfill requests even if the amount requested 
is more than, it will return a success, otherwise it will return an error

```swift
iap.useConsumable("com.myproductId", scalar: 12) { (model:IAPModel?, error:NSError?) -> () in

}
```

## Non-Consumable

```swift
iap.useConsumable("com.my.nonconsumable") { (model:IAPModel?, error:NSError?) -> () in

}
```

## Entitlements

```swift
iap.listEntitlements() { (model:IAPModel?, error:NSError?) -> () in

}
```

## Validate Entitlement

```swift
iap.validateEntitlement("myEntitlement") { (model:IAPModel?, error:NSError?) -> () in

}
```

## Api status check

```swift
iap.status() { (running:Bool, model:IAPTupleModel?, error:NSError?) -> () in

}
```


