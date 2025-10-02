import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushHelper {
  static const MethodChannel _platform =
  MethodChannel("io.igrant.data4diabetes.channel");

  /// Initialize Firebase Push Notifications
  static Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission (iOS only, does nothing on Android)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("Push permission granted: ${settings.authorizationStatus}");

    // Get FCM token and send to SDK
    String? token = await messaging.getToken();
    if (token != null) {
      await _sendTokenToSDK(token);
    }

    // Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message.data);
    });

    // User taps on notification (background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message.data);
    });

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Internal method to forward FCM token to Android SDK
  static Future<void> _sendTokenToSDK(String token) async {
    try {
      await _platform.invokeMethod("updateFCMToken", {"token": token});
      debugPrint("FCM token sent to SDK: $token");
    } on PlatformException catch (e) {
      debugPrint("Failed to send FCM token to SDK: $e");
    }
  }

  /// Internal method to forward push notifications to SDK
  static Future<void> _handleMessage(Map<String, dynamic> data) async {
    try {
      await _platform.invokeMethod(
        "handleNotification",
        data.map((key, value) => MapEntry(key, value.toString())),
      );
      debugPrint("Notification forwarded to SDK: $data");
    } on PlatformException catch (e) {
      debugPrint("Failed to forward notification to SDK: $e");
    }
  }
}

/// Top-level background message handler (required by Firebase Messaging)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  const MethodChannel platform = MethodChannel("io.igrant.data4diabetes.channel");

  try {
    await platform.invokeMethod(
      "handleNotification",
      message.data.map((key, value) => MapEntry(key, value.toString())),
    );
    debugPrint("Background notification forwarded to SDK: ${message.data}");
  } on PlatformException catch (e) {
    debugPrint("Failed to forward background notification to SDK: $e");
  }
}
