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
import com.facebook.react.bridge.ReadableType
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
    }

    // Register for push notifications
    private fun registerForPushNotifications() {
        // Register KlaviyoPushService for receiving push notifications
        // application.registerService(KlaviyoPushService::class.java)

        Log.d(TAG, "registering for Push Notifications")

        // Fetches the current push token and registers with Push SDK
        FirebaseMessaging.getInstance().token.addOnSuccessListener { pushToken ->
            Klaviyo.setPushToken(pushToken)
        }
    }

    @ReactMethod
    fun identify(userDetails: ReadableMap) {
        Klaviyo.setProfileAttribute(ProfileKey.CUSTOM("platform"), "android");
        Klaviyo.setProfileAttribute(ProfileKey.CUSTOM("source"), "apptile_mobile_app");

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
    fun resetIdentity() {
        Klaviyo.resetProfile()
    }

    @ReactMethod
    fun sendEvent(eventMetric: String, eventData: ReadableMap) {
        val event = Event(eventMetric)

        if(eventData.hasKey("value")) {
            event.setValue(eventData.getDouble("value").toString())
        }

        if(eventData.hasKey("properties")) {
            val properties = eventData.getMap("properties")
            val propertyKeys = properties!!.keySetIterator()
            while (propertyKeys.hasNextKey()) {
                val key = propertyKeys.nextKey()
                val type = properties.getType(key)
                val value: Any? = when (type) {
                    ReadableType.Null -> "null"
                    ReadableType.Boolean -> properties.getBoolean(key)
                    ReadableType.Number -> properties.getDouble(key)
                    ReadableType.String -> properties.getString(key)
                    ReadableType.Map -> properties.getMap(key)
                    ReadableType.Array -> properties.getArray(key)
                    else -> "Unsupported type"
                }

                event.setProperty(EventKey.CUSTOM(key), value.toString())
            }
        }

        Klaviyo.createEvent(event)
    }

    companion object {
        const val NAME = "KlaviyoModule"
        private const val TAG = "KlaviyoModule"
    }
}
