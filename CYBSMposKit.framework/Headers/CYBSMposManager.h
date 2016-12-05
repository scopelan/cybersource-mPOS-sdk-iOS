//
//  CYBSMposManager.h
//  CYBSMposKit
//
//  Created by CyberSource on 5/22/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

#import "CYBSMposPaymentRequest.h"
#import "CYBSMposPaymentResponse.h"
#import "CYBSMposReceiptRequest.h"
#import "CYBSMposSettings.h"
#import "CYBSMposTransactionSearchQuery.h"
#import "CYBSMposTransactionSearchResult.h"
#import "CYBSMposTransaction.h"
#import "CYBSMposRefundRequest.h"
#import "CYBSMposVoidRequest.h"
#import "CYBSMposUISettings.h"
#import "CYBSMposError.h"

@protocol CYBSMposManagerDelegate;

/**
 A CYBSMposManager object let you perform MPOS operations. It is the central point of CyberSource MPOS SDK.
 */
@interface CYBSMposManager : NSObject

/**
 @brief The CyberSource MPOS SDK settings.
 @see CYBSMposSettings
 */
@property (nonatomic, copy, nonnull) CYBSMposSettings *settings;
/**
 @brief The CyberSource MPOS SDK UI settings.
 @see CYBSMposUISettings
 */
@property (nonatomic, copy, nonnull) CYBSMposUISettings *uiSettings;
/**
 @brief The CYBSMposManager delegate object.
 @see CYBSMposManagerDelegate
 */
@property (nonatomic, weak, nullable) id<CYBSMposManagerDelegate> delegate;

/**
 @brief Initializes the CYBSMposManager object with the specified SDK settings.

 @param settings The CyberSource MPOS SDK settings.
 */
- (nonnull instancetype)initWithSettings:(nonnull CYBSMposSettings *)settings;

/**
 @brief Initializes the CYBSMposManager object with the specified environment, and device ID.

 @param environment The CyberSource Environment (Live or Test)
 @param deviceID oAuth device ID
 @see CYBSMposEnvironment
 */
- (nonnull instancetype)initWithEnvironment:(CYBSMposEnvironment)environment
                                   deviceID:(nonnull NSString *)deviceID;

/**
 @brief Performs payment capture

 @param request the payment request
 @param parentViewController the Application view controller
 @param delegate the delegate object
 @see CYBSMposPaymentRequest
 @see CYBSMposManagerDelegate
 */
- (void)performPayment:(nonnull CYBSMposPaymentRequest *)request
  parentViewController:(nonnull UIViewController *)parentViewController
              delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Performs refund

 @param request the refund request
 @param delegate the delegate object
 @see CYBSMposRefundRequest
 @see CYBSMposManagerDelegate
 */
- (void)performRefund:(nonnull CYBSMposRefundRequest *)request
             delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Performs void

 @param request the void request
 @param delegate the delegate object
 @see CYBSMposVoidRequest
 @see CYBSMposManagerDelegate
 */
- (void)performVoid:(nonnull CYBSMposVoidRequest *)request
           delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Performs transaction search

 @param query the TransactionSearchQuery object
 @param accessToken the oAuth access token
 @param delegate the delegate object
 @see CYBSMposTransactionSearchQuery
 @see CYBSMposManagerDelegate
 */
- (void)performTransactionSearch:(nonnull CYBSMposTransactionSearchQuery *)query
                     accessToken:(nonnull NSString *)accessToken
                        delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Retrieves next transaction search result

 @param currentResult the current CYBSMposTransactionSearchResult object
 @param accessToken the oAuth access token
 @param delegate the delegate object
 @see CYBSMposTransactionSearchResult
 @see CYBSMposManagerDelegate
 */
- (void)nextTransactionSearchResult:(nonnull CYBSMposTransactionSearchResult *)currentResult
                        accessToken:(nonnull NSString *)accessToken
                           delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Retrieves transaction detail

 @param transactionID the transaction ID
 @param accessToken the oAuth access token
 @param delegate the delegate object
 @see CYBSMposManagerDelegate
 */
- (void)getTransactionDetail:(nonnull NSString *)transactionID
                 accessToken:(nonnull NSString *)accessToken
                    delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

/**
 @brief Sends transaction receipt

 @param request the receipt request
 @param delegate the delegate object
 @see CYBSMposReceiptRequest
 @see CYBSMposManagerDelegate
 */
- (void)sendReceipt:(nonnull CYBSMposReceiptRequest *)request
           delegate:(nullable id<CYBSMposManagerDelegate>)delegate;

@end

@protocol CYBSMposManagerDelegate <NSObject>

@optional

- (void)performPaymentDidFinish:(nullable CYBSMposPaymentResponse *)result
                          error:(nullable NSError *)error;

- (void)performTransactionSearchDidFinish:(nullable CYBSMposTransactionSearchResult *)result
                                    error:(nullable NSError *)error;

- (void)getTransactionDetailDidFinish:(nullable CYBSMposTransaction *)transaction
                                error:(nullable NSError *)error;

@end
