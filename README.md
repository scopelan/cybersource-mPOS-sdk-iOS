# CyberSource iOS MPOS SDK Integration Guide
The CyberSource MPOS SDK provides a Semi-Integrated Solution for EMV payment
processing.

The merchant's app invokes this SDK to complete an EMV transaction. The SDK
handles the complex EMV workflow and securely submits the EMV transaction to
CyberSource for processing. The merchant's app never touches any EMV data at any
point.

## Including the MPOS SDK

1. Include *CYBSMposKit.framework* in the merchant's app. Select **Target > In Embedded Binaries**, press the plus (+) and select the framework. Once the project is included, verify that the path to these frameworks are added correctly in **Build Settings** tab, in section **Search Paths**. 

2. If the application is developed in Swift, the application must
have a bridging header file created because the _CYBSMposKit.framework_ is written
in Objective-C.

```
// Example: CybsMposDemo-Bridging-Header.h
#ifndef CYBSMposDemo_Bridging_Header_h
#define CYBSMposDemo_Bridging_Header_h
#import <CYBSMposKit/CYBSMposKit.h>
#endif
```

## Creating and Submitting an EMV Transaction

1. Initialize the SDK with the environment and device ID.

```
// Swift 2.3
let settings = CYBSMposSettings(environment: .Test, deviceID: "your_device_id")
let manager = CYBSMposManager(settings: settings)
```
```
// Objective-C
CYBSMposSettings *settings = [[CYBSMposSettings alloc] initWithEnvironment: CYBSMposEnvironmentTest
                                                                  devideID: "your_device_id"];
CYBSMposManager *manager = [[CYBSMposManager alloc] initWithSettings:settings];
```

2. Create the `CYBSMposPaymentRequest`. For more details, refer to _CYBSMposPaymentRequest.h_.

```
// Swift 2.3
let paymentRequest =
  CYBSMposPaymentRequest(merchantID: "your_merchant_id",
                        accessToken: "your_access_token",
              merchantReferenceCode: "your_reference_code",
                           currency: "USD",
                             amount: 4.99,
                          entryMode: .CardReader)
```
```
// Objective-C
CYBSMposPaymentRequest *paymentRequest =
  [[CYBSMposPaymentRequest alloc] initWithMerchantID:@"your_merchant_id"
                                         accessToken:@"your_access_token"
                               merchantReferenceCode:@"your_reference_code"
                                            currency:@"USD"
                                              amount:@4.99
                                           entryMode:CYBSMposPaymentRequestEntryModeCardReader];
```
3. Start the payment flow.

```
// Swift 2.3
manager.performPayment(paymentRequest, parentViewController: self,
  delegate: self)
```
```
// Objective-C
[manager performPayment:paymentRequest parentViewController:self
  delegate:self];
```

4. Handle the payment response.

```
// Swift 2.3
func performPaymentDidFinish(result: CYBSMposPaymentResult?,
                              error: NSError?) {
  if error != nil {
    // Error handling
  } else {
  }
}
```
```
// Objective-C
 - (void) performPaymentDidFinish:(nullable CybsMposPaymentResult *)result
                           error:(nullable NSError *)error {
  if (error != nil) {
    // Error handling
  } else {
  }
}
```

## Creating and Submitting a transaction using Magstripe Only

1.	Include _CYBSMposKit.framework_ in your app. Select **Target > In Embedded Binaries**, press the plus (+) and select the framework. Once included, make sure in Build Settings tab, the path to these frameworks are added correctly in the **Search Paths** section.

2.	If the application is developed in Swift, the application must have a bridging header file created because the _CYBSMposKit.framework_ is written in Objective-C.

```
// Example: CybsMposDemo-Bridging-Header.h
#ifndef CYBSMposDemo_Bridging_Header_h
#define CYBSMposDemo_Bridging_Header_h
#import <CYBSMposKit/CYBSMposKit.h>
#endif
```

3.	Initialize the SDK with environment and device ID.

```
//Swift 2.3
let settings = CYBSMposSettings(environment: .Test, deviceID: "your_device_id")
let manager = CYBSMposManager(settings: settings)
```

4.	Create `CYBSMposPaymentRequest`. 

* To enable Endless Aisle transactions, use `commerceIndicator: .Ecomm`. 
* To enable tokenization, use `enableTokenization: True`.

```
let paymentRequest = CYBSMposPaymentRequest(merchantID: "your_merchant_id",
accessToken: "your_access_token",
merchantReferenceCode: "your_reference_code", 
currency: "USD",
amount: 4.99,
entryMode: .CardReader, 
entryType: .Swipe
commerceIndicator: .Ecomm  \\ use only to enable Endless Aisle transactions
enableTokenization: True)  \\ use only to enable tokenization
```

* In the reference app, go to the Settings screen, select the **Swipe** option under the **EntryType** section.

5.	Start the payment flow.

```
manager.performPayment(paymentRequest, parentViewController: self, delegate: self)
```
6.	Handle the payment response.

```
func performPaymentDidFinish(result: CYBSMposPaymentResult?, error: NSError?) {
if error != nil {
   // Error handling
} else {
}
}
```

