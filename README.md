# CyberSource iOS MPOS SDK Integration Guide
The CyberSource MPOS SDK provides a Semi-Integrated Solution for EMV payment
processing.

The merchant's app invokes this SDK to complete an EMV transaction. The SDK
handles the complex EMV workflow and securely submits the EMV transaction to
CyberSource for processing. The merchant's app never touches any EMV data at any
point.

## Using the MPOS SDK
1. Include *CYBSMposKit.framework* in the merchant's app. Select Target,
In Embedded Binaries, press the plus (+) and select the framework. Once
included, make sure in *Build Settings* tab, in section *Search Paths* the path
to these frameworks are added correctly.
2. If the application is developed in *Swift*, the application must
have a bridging header file created because the CYBSMposKit.framework is written
in *Objective-C*.
```
// Example: CybsMposDemo-Bridging-Header.h
#ifndef CYBSMposDemo_Bridging_Header_h
#define CYBSMposDemo_Bridging_Header_h
#import <CYBSMposKit/CYBSMposKit.h>
#endif
```

### Create and Submit an EMV transaction
1. Initialize the SDK with environment and device id
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
2. Create the CYBSMposPaymentRequest. For more details, refer to CYBSMposPaymentRequest.h
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
3. Start Payment flow
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
4. Handle Payment response
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

## SDK Error Messages

Error Message | Description | Solution
------------- | ----------- | --------
UNKNOWN_READER_ERROR| The card reader was not recognized. | Navigate to the Android phone settings and select **Applications > Application manager > Demo app**. Enable audio, storage, and all related options.
INTERNAL_ERROR | There was a problem in the CyberSource Environment. | Contact CyberSource technical support.
TRANSACTION_TERMINATED | The transaction request failed. | Ensure that you are using the right credentials for your environment. The Test and Production environments use different credentials.
