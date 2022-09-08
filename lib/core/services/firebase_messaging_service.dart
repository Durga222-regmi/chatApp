import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:group_chat_fb/injection_container.dart';

class FirebaseMessagingService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static void registerNotification(String uid) async {
    try {
      await firebaseMessaging.requestPermission();
      FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
        RemoteNotification? notification = remoteMessage.notification;
        AndroidNotification? androidNotification =
            remoteMessage.notification?.android;

        if (notification != null && androidNotification != null) {
          _showNotification(remoteMessage.data);
        }
      });

      final token = await firebaseMessaging.getToken();
      final userDoc =
          await sl.call<FirebaseFirestore>().collection("users").doc(uid).get();
      if (userDoc.exists) {
        await userDoc.reference.update({"pushToken": token});
      } else {
        log("user no existed ");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static void configLocalNotification() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static _showNotification(message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }
}
