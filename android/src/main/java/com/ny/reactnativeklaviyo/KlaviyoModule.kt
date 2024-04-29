package com.ny.reactnativeklaviyo

import android.app.Application
import android.util.Log

import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.klaviyo.analytics.Klaviyo
import com.klaviyo.analytics.model.ProfileKey
import com.klaviyo.pushFcm.KlaviyoPushService
import com.google.firebase.messaging.FirebaseMessaging
import com.klaviyo.analytics.model.Event
import com.klaviyo.analytics.model.EventKey
import com.klaviyo.analytics.model.EventMetric

class KlaviyoModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return NAME
    }

    // Initialize Klaviyo SDK and register for push notifications
    @ReactMethod
    fun initializeKlaviyoSDK(apiKey: String) {
        val application = reactApplicationContext.applicationContext as Application

        Log.d(TAG, "Initializing Klaviyo SDK with apiKey: $apiKey")

        // Initialize Klaviyo SDK
        Klaviyo.initialize(apiKey, application)

        // Register for push notifications
        registerForPushNotifications()

        Klaviyo.setProfileAttribute(ProfileKey.CUSTOM("platform"), "android");
        Klaviyo.setProfileAttribute(ProfileKey.CUSTOM("source"), "apptile_mobile_app");
    }

    // Register for push notifications
    // @ReactMethod
    fun registerForPushNotifications() {
        // Register KlaviyoPushService for receiving push notifications
        // application.registerService(KlaviyoPushService::class.java)

        Log.d(TAG, "registering for Push Notifications")

        // Fetches the current push token and registers with Push SDK
        FirebaseMessaging.getInstance().token.addOnSuccessListener { pushToken ->
            Klaviyo.setPushToken(pushToken)
        }
    }

    @ReactMethod
    fun setExternalId(externalId: String) {
        Klaviyo.setExternalId(externalId)
    }

    @ReactMethod
    fun getExternalId(callback: Callback) {
        val externalId = Klaviyo.getExternalId()
        if (externalId != null) {
            // No error, so pass null for the error parameter, and pass the externalId as the second parameter
            callback.invoke(null, externalId)
        } else {
            // Handle the scenario where externalId is null by passing an error message as the first parameter
            callback.invoke("External ID not found", null)
        }
    }

    @ReactMethod
    fun identify(userDetails: ReadableMap) {
        if(userDetails.hasKey("email")) {
            Klaviyo.setEmail(userDetails.getString("email").toString());
        }

        if(userDetails.hasKey("phone_number")) {
            Klaviyo.setPhoneNumber(userDetails.getString("phone_number").toString());
        }

        if(userDetails.hasKey("first_name")) {
            Klaviyo.setProfileAttribute(ProfileKey.FIRST_NAME, userDetails.getString("first_name").toString());
        }

        if(userDetails.hasKey("last_name")) {
            Klaviyo.setProfileAttribute(
                ProfileKey.LAST_NAME,
                userDetails.getString("last_name").toString()
            );
        }
    }

    @ReactMethod
    fun sendEvent(eventMetric: String, eventData: ReadableMap) {
        val event = Event(eventMetric)

        if(eventData.hasKey("value")) {
            event.setValue(eventData.getDouble("value"))
        }

        if(eventData.hasKey("properties")) {
            val properties = eventData.getMap("properties")
            val propertyKeys = properties!!.keySetIterator()
            while (propertyKeys.hasNextKey()) {
                val key = propertyKeys.nextKey()
                val value = properties.getType(key)

                event.setProperty(EventKey.CUSTOM(key), value)
            }
        }
    }

    // @ReactMethod
    // fun getExternalId(callback: Callback) {
    //     callback.invoke(Klaviyo.getExternalId())
    // }

    // @ReactMethod
    // fun getExternalId(promise: Promise) {
    //     try {
    //         val externalId = Klaviyo.getExternalId()
    //         if (externalId != null) {
    //             promise.resolve(externalId)
    //         } else {
    //             promise.reject("error", "External ID is null")
    //         }
    //     } catch (e: Exception) {
    //         promise.reject("error", e.localizedMessage)
    //     }
    // }

    companion object {
        const val NAME = "KlaviyoModule"
        private const val TAG = "KlaviyoModule"
    }
}
