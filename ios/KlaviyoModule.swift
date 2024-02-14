// //
// //  KlaviyoModule.swift
// //  KlaviyoModule
// //
// //  Copyright © 2021 grassper. All rights reserved.
// //

// import KlaviyoSwift

// @objc(KlaviyoModule)
// class KlaviyoModule: NSObject {
//   @objc
//   public static func initializeKlaviyoSDK(_ value: String) {
//     KlaviyoSDK().initialize(with: value)
//   }

//   @objc
//   public static func setExternalId(_ value: String) {
//     KlaviyoSDK().set(externalId: value)
//   }

//   // @objc
//   // public static func getExternalId() -> String {
//   //   return KlaviyoSDK().externalId ?? ""
//   // }

//   // @objc(getExternalId:rejecter:)
//   // func getExternalId(resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) {
//   //   if let externalId = KlaviyoSDK().externalId {
//   //     resolve(externalId)
//   //   } else {
//   //     reject("no_id", "There is no external ID set", nil)
//   //   }
//   // }

//   @objc(getExternalId:)
//   public static func getExternalId(callback: RCTResponseSenderBlock) {
//     if let externalId = KlaviyoSDK().externalId {
//       callback([NSNull(), externalId])
//     } else {
//       callback(["External ID not found", NSNull()])
//     }
//   }

//   @objc
//   func setPushToken(tokenData: Data) {
//     KlaviyoSDK().setPushToken(tokenData)
//   }

//   @objc
//   class func setPushTokenNative(tokenData: Data) {
//     KlaviyoSDK().setPushToken(tokenData)
//   }
// }



import Foundation
import KlaviyoSwift

@objc(KlaviyoModule)
class KlaviyoModule: NSObject {
    private let sdk = KlaviyoSDK();
    static let shared = KlaviyoModule();

    @objc
    override init() {
        super.init()
        // sdk = KlaviyoSDK()
    }

    @objc
    public func initializeKlaviyoSDK(_ apiKey: String) {
        sdk.initialize(with: apiKey)
        // KlaviyoModule.shared.sdk.initialize(with: apiKey);
    }

    @objc
    func setExternalId(_ externalId: String) {
        sdk.set(externalId: externalId);
        // KlaviyoModule.shared.sdk.set(externalId: externalId);
    }

    @objc
    func getExternalId(_ callback: @escaping RCTResponseSenderBlock) {
        if let externalId = sdk.externalId {
        // if let externalId = KlaviyoModule.shared.sdk.externalId {
            callback([NSNull(), externalId])
        } else {
            callback(["External ID not found", NSNull()])
        }
    }

    @objc
    func setPushToken(_ tokenData: String) {
        sdk.set(pushToken: tokenData);
        // KlaviyoModule.shared.sdk.set(pushToken: tokenData);
    }
    
    func handle(didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) -> Bool {
        let handled = sdk.handle(notificationResponse: response, withCompletionHandler: completionHandler);
        return handled;
    }
}
// ReactNativeAwesomeLibrary

extension KlaviyoModule: UNUserNotificationCenterDelegate {
    
    @objc
    public static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let handled = KlaviyoModule.shared.handle(didReceive: response, withCompletionHandler: completionHandler);
    }
}
