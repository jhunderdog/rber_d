import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  Future initialize() async {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        getRideRequestId(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        getRideRequestId(message);
      },
      onResume: (Map<String, dynamic> message) async {
        getRideRequestId(message);
      },
    );
  }

  Future<String> getToken() async {
    String token = await firebaseMessaging.getToken();
    print("this is token Id::");
    print(token);
    driversRef.child(currentfirebaseUser.uid).child("token").set(token);
    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }

  String getRideRequestId(Map<String, dynamic> message) {
    String rideRequestId = "";
    if (Platform.isAndroid) {
      print("This is Ride Request Id :: ");
      rideRequestId = message['data']['ride_request_id'];
      print(rideRequestId);
    } else {
      print("This is Ride Request Id :: ");
      rideRequestId = message['ride_request_id'];
      print(rideRequestId);
    }
    return rideRequestId;
  }
}
