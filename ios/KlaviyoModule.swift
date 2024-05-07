
import Foundation
import KlaviyoSwift

@objc(KlaviyoModule)
class KlaviyoModule: NSObject {
    private let sdk = KlaviyoSDK();
    static let shared = KlaviyoModule();

    @objc
    override init() {
        super.init()
    }

    @objc
    public func initializeKlaviyoSDK(_ apiKey: String) {
        sdk.initialize(with: apiKey)
    }

    @objc
    func identify(_ userDetails: NSDictionary) {
        sdk.set(profileAttribute: .custom(customKey: "platform"), value: "ios");
        sdk.set(profileAttribute: .custom(customKey: "source"), value: "apptile_mobile_app");
        
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
    func resetIdentity() {
        sdk.resetProfile()
    }

    @objc
    func sendEvent(_ eventMetric: String, eventData: NSDictionary) {
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
