import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) {
        print('onMessage: $message');
        showNotification(message['notification']['title']);
        return;
      }, onResume: (Map<String, dynamic> message) {
        print('onResume: $message');
        return;
      }, onLaunch: (Map<String, dynamic> message) {
        print('onLaunch: $message');
        return;
      });

      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }

  showNotification(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future<bool> sendFcmMessage() async {
    try {
      final token =  await _firebaseMessaging.getToken();
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
        "key=AAAAc_RC2qQ:APA91bG1SVNqtioIqgJQbTWw4vy7O3xp6oJDXVyn8SwnsG-IMz4qqnwqynHfgL-LTwcm4XnY8iw3PGVOZ-7_XDQuKtMVGhyiehTyC_2xRSpNj7TTTBhOkKAg3v2NC8PfVUaT9-Y94Swb",
      };
      var request = jsonEncode({
        "notification": {
          "title": 'You are put the button',
        },
        "priority": "high",
        "to": token,
      });

      var client = new http.Client();
      var response =
      await client.post(url, headers: header, body: request);
      return true;
    } catch (e) {
      print(e);
      return false;
    }}
}
