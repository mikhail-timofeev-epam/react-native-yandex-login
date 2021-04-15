#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(YandexLogin, NSObject)

RCT_EXTERN_METHOD(timeToStartCheckout: (NSString *) id
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(activate:(NSString)id)
@end
