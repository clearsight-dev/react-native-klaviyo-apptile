package com.grassper.reactnativeiconpicker

import android.app.Application
import android.util.Log

import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.klaviyo.analytics.Klaviyo
import com.klaviyo.pushFcm.KlaviyoPushService
import com.google.firebase.messaging.FirebaseMessaging

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
