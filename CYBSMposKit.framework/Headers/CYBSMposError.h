//
//  CYBSMposError.h
//  CYBSMposKit
//
//  Created by CyberSource on 10/11/16.
//  Copyright © 2016 CyberSource. All rights reserved.
//

FOUNDATION_EXPORT NSString * __nonnull const CYBSMposCardReaderErrorDomain;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposConnectionErrorDomain;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposOAuthErrorDomain;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposTransactionErrorDomain;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposTransactionSearchErrorDomain;
FOUNDATION_EXPORT NSString * __nonnull const CYBSMposReceiptErrorDomain;

typedef NS_ENUM(NSInteger, CYBSMposCardReaderError) {
  CYBSMposCardReaderErrorAWCWalkerInvalidInput = 1001,
  CYBSMposCardReaderErrorAWCWalkerInvalidInputNotNumeric,
  CYBSMposCardReaderErrorAWCWalkerInvalidInputInputValueOutOfRange,
  CYBSMposCardReaderErrorAWCWalkerInvalidInputInvalidDataFormat,
  CYBSMposCardReaderErrorAWCWalkerInvalidInputNoAcceptAmountForThisTransactionType,
  CYBSMposCardReaderErrorAWCWalkerInvalidInputNotAcceptCashbackForThisTransactionType,
  CYBSMposCardReaderErrorAWCWalkerDeviceReset,
  CYBSMposCardReaderErrorAWCWalkerCommError,
  CYBSMposCardReaderErrorAWCWalkerUnknown,
  CYBSMposCardReaderErrorAWCWalkerAudioFailToStart,
  CYBSMposCardReaderErrorAWCWalkerAudioNotYetStarted,
  CYBSMposCardReaderErrorAWCWalkerIllegalStateException,
  CYBSMposCardReaderErrorAWCWalkerCommandNotAvailable,
  CYBSMposCardReaderErrorAWCWalkerAudioRecordingPermissionDenied,
  CYBSMposCardReaderErrorAWCWalkerBackgroundTimeout,
  CYBSMposCardReaderErrorAWCWalkerAudioFailToStart_OtherAudioIsPlaying,
  CYBSMposCardReaderErrorAWCWalkerDeviceBusy,
  CYBSMposCardReaderErrorAWCWalkerTerminated = 1101,
  CYBSMposCardReaderErrorAWCWalkerDeclined,
  CYBSMposCardReaderErrorAWCWalkerSetAmountCancelOrTimeout,
  CYBSMposCardReaderErrorAWCWalkerCapkFail,
  CYBSMposCardReaderErrorAWCWalkerNotIcc,
  CYBSMposCardReaderErrorAWCWalkerCardBlocked,
  CYBSMposCardReaderErrorAWCWalkerDeviceError,
  CYBSMposCardReaderErrorAWCWalkerCardNotSupported,
  CYBSMposCardReaderErrorAWCWalkerMissingMandatoryData,
  CYBSMposCardReaderErrorAWCWalkerNoEmvApps,
  CYBSMposCardReaderErrorAWCWalkerInvalidIccData,
  CYBSMposCardReaderErrorAWCWalkerConditionsOfUseNotSatisfied,
  CYBSMposCardReaderErrorAWCWalkerApplicationBlocked,
  CYBSMposCardReaderErrorAWCWalkerIccCardRemoved
};

typedef NS_ENUM(NSInteger, CYBSMposConnectionError) {
  CYBSMposConnectionErrorTimeout = -1001,
  CYBSMposConnectionErrorHttpBadRequest = 400,
  CYBSMposConnectionErrorHttpUnauthorized = 401,
  CYBSMposConnectionErrorHttpForbidden = 403,
  CYBSMposConnectionErrorHttpNotFound = 404,
  CYBSMposConnectionErrorHttpServer = 500,
  CYBSMposConnectionErrorHttpGatewayTimeout = 504
};

typedef NS_ENUM(NSInteger, CYBSMposOAuthError) {
  CYBSMposOAuthErrorInvalidToken = 101
};

typedef NS_ENUM(NSInteger, CYBSMposTransactionError) {
  CYBSMposTransactionErrorMissingFields = 101,
  CYBSMposTransactionErrorInvalidData = 102,
  CYBSMposTransactionErrorPartialApproved = 110,
  CYBSMposTransactionErrorGeneralSystemFailure = 150,
  CYBSMposTransactionErrorServerTimeout = 151,
  CYBSMposTransactionErrorDidNotFinish = 152,
  CYBSMposTransactionErrorDidNotPassAvs = 200,
  CYBSMposTransactionErrorIssuingBankHasQuestions = 201,
  CYBSMposTransactionErrorExpiredCard = 202,
  CYBSMposTransactionErrorGeneralDecline = 203,
  CYBSMposTransactionErrorInsufficientFunds = 204,
  CYBSMposTransactionErrorStolenOrLostCard = 205,
  CYBSMposTransactionErrorIssuingBankUnavailable = 207,
  CYBSMposTransactionErrorInactiveCard = 208,
  CYBSMposTransactionErrorCidDidNotMatch = 209,
  CYBSMposTransactionErrorCreditLimit = 210,
  CYBSMposTransactionErrorInvalidCvn = 211,
  CYBSMposTransactionErrorNegativeFile = 221,
  CYBSMposTransactionErrorDidNotPassCvnCheck = 230,
  CYBSMposTransactionErrorInvalidAccountNumber = 231,
  CYBSMposTransactionErrorCardTypeNotAccepted = 232,
  CYBSMposTransactionErrorGeneralDeclineByProcessor = 233,
  CYBSMposTransactionErrorMerchantConfiguration = 234,
  CYBSMposTransactionErrorCaptureAmountExceeds = 235,
  CYBSMposTransactionErrorProcessorFailure = 236,
  CYBSMposTransactionErrorAuthorizationReversed = 237,
  CYBSMposTransactionErrorAuthorizationCaptured = 238,
  CYBSMposTransactionErrorAmountDidNotMatch = 239,
  CYBSMposTransactionErrorInvalidCardType = 240,
  CYBSMposTransactionErrorInvalidRequestID = 241,
  CYBSMposTransactionErrorNoCorrespondingAuthorization = 242,
  CYBSMposTransactionErrorAlreadySettledOrReversed = 243,
  CYBSMposTransactionErrorNotVoidable = 246,
  CYBSMposTransactionErrorCaptureVoided = 247,
  CYBSMposTransactionErrorProcessorTimeout = 250,
  CYBSMposTransactionErrorStandAloneCreditNotAllowed = 254
};

typedef NS_ENUM(NSInteger, CYBSMposTransactionSearchError) {
  CYBSMposTransactionSearchErrorMissingFields = 101,
  CYBSMposTransactionSearchErrorInvalidData = 102
};

typedef NS_ENUM(NSInteger, CYBSMposReceiptError) {
  CYBSMposReceiptErrorMissingFields = 101,
  CYBSMposReceiptErrorInvalidData = 102
};
