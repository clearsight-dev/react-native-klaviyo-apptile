// //
// //  IconPickerModule.m
// //  IconPickerModule
// //
// //  Copyright © 2021 grassper. All rights reserved.
// //

// // #import <React/RCTBridgeModule.h>
// #import "KlaviyoModule.h"

// // @interface RCT_EXTERN_MODULE(KlaviyoModule, NSObject)

// // RCT_EXTERN_METHOD(initializeKlaviyoSDK:(NSString *)value)
// // RCT_EXTERN_METHOD(setExternalId:(NSString *)value)
// // // RCT_EXTERN_METHOD(getExternalId:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
// // RCT_EXTERN_METHOD(getExternalId:(RCTResponseSenderBlock)callback)
// // RCT_EXTERN_METHOD(setPushToken:(NSData *)tokenData)
// // RCT_EXTERN_METHOD(setPushTokenNative:(NSData *)tokenData)

// // @end

// @implementation KlaviyoModule
// RCT_EXPORT_MODULE();

// RCT_EXPORT_METHOD(initializeKlaviyoSDK: (NSString *)apiKey)
// {
//     [KlaviyoModule initializeKlaviyoSDK: apiKey];
// }

// RCT_EXPORT_METHOD(setExternalId: (NSString *)externalId)
// {
//     [KlaviyoModule setExternalId: externalId];
// }

#import "KlaviyoModule.h"
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(KlaviyoModule, NSObject)

RCT_EXTERN_METHOD(initializeKlaviyoSDK:(NSString *)apiKey)
RCT_EXTERN_METHOD(setExternalId:(NSString *)externalId)
RCT_EXTERN_METHOD(getExternalId:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(setPushToken:(NSString *)tokenData)

@end
