
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
        
        sdk.set(profile: Profile(properties: [
            "platform": "ios",
            "source": "apptile_mobile_app"
        ]))
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
    func identify(_ userDetails: NSDictionary) {
        if let email = userDetails["email"] as? String {
            sdk.set(email: email)
        }

        if let phoneNumber = userDetails["phone_number"] as? String {
            sdk.set(phoneNumber: phoneNumber)
        }

        if let firstName = userDetails["first_name"] as? String {
            sdk.set(profileAttribute: .firstName, value: firstName)
        }

        if let lastName = userDetails["last_name"] as? String {
            sdk.set(profileAttribute: .lastName, value: lastName)
        }
    }

    @objc
    func sendEvent(_ eventMetric: String, _ eventData: NSDictionary) {
        let value: Double? = eventData["value"] as? Double
        var properties: [String : Any]? = eventData["properties"] as? [String: Any]
        
        for (key, value) in properties ?? [:] {
            properties?[key] = value
        }

        let event = Event(name: .CustomEvent(eventMetric), properties: properties, value: value)

        sdk.create(event: event)
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

extension KlaviyoModule: UNUserNotificationCenterDelegate {
    
    @objc
    public static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        _ = KlaviyoModule.shared.handle(didReceive: response, withCompletionHandler: completionHandler);
    }
}
