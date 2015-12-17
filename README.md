# InAppPurchase

Consumables
	Quantity Based
	Time Based

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


