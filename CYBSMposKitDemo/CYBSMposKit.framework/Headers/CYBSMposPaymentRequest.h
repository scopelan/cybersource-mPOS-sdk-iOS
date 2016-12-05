//
//  CYBSMposPaymentRequest.h
//  CYBSMposKit
//
//  Created by CyberSource on 5/22/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CYBSMposPaymentRequestEntryMode) {
  CYBSMposPaymentRequestEntryModeKeyEntry = 0,
  CYBSMposPaymentRequestEntryModeCardReader
};

@interface CYBSMposPaymentRequestPurchaseTotal : NSObject

@property (nonatomic, strong, nonnull) NSString *currency;
@property (nonatomic, strong, nonnull) NSDecimalNumber *amount;

- (nonnull instancetype)initWithCurrency:(nonnull NSString *)currency amount:(nonnull NSDecimalNumber *)amount;
- (nonnull NSDictionary *)dictionary;

@end

@interface CYBSMposPaymentRequest : NSObject

@property (nonatomic, strong, nonnull) NSString *merchantID;
@property (nonatomic, strong, nonnull) NSString *accessToken;
@property (nonatomic, strong, nonnull) NSString *merchantReferenceCode;
@property (nonatomic, strong, nonnull) CYBSMposPaymentRequestPurchaseTotal *purchaseTotal;
@property (nonatomic, assign) CYBSMposPaymentRequestEntryMode entryMode;

- (nonnull instancetype)initWithMerchantID:(nonnull NSString *)merchantID
                               accessToken:(nonnull NSString *)accessToken
                     merchantReferenceCode:(nonnull NSString *)merchantReferenceCode
                                  currency:(nonnull NSString *)currency
                                    amount:(nonnull NSDecimalNumber *)amount
                                 entryMode:(CYBSMposPaymentRequestEntryMode)entryMode;
- (nonnull NSDictionary *)dictionary;

@end
