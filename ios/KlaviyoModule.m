
#import "KlaviyoModule.h"
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(KlaviyoModule, NSObject)

RCT_EXTERN_METHOD(initializeKlaviyoSDK:(NSString *)apiKey)
RCT_EXTERN_METHOD(setExternalId:(NSString *)externalId)
RCT_EXTERN_METHOD(getExternalId:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(identify:(NSDictionary *)userDetails)
RCT_EXTERN_METHOD(sendEvent:(NSString *)eventMetric eventData:(NSDictionary *)eventData)
RCT_EXTERN_METHOD(setPushToken:(NSString *)tokenData)

@end
