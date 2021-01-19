import 'package:drivers_app/Models/rideDetails.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  Future initialize() async {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message));
      },
      onLaunch: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message));
      },
      onResume: (Map<String, dynamic> message) async {
        retrieveRideRequestInfo(getRideRequestId(message));
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
      // print("This is Ride Request Id :: ");
      rideRequestId = message['data']['ride_request_id'];
      // print(rideRequestId);
    } else {
      // print("This is Ride Request Id :: ");
      rideRequestId = message['ride_request_id'];
      // print(rideRequestId);
    }
    return rideRequestId;
  }

  void retrieveRideRequestInfo(String rideRequestId) {
    newRequestsRef
        .child(rideRequestId)
        .once()
        .then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        double pickUpLocationLat =
            double.parse(dataSnapShot.value['pickup']['latitude'].toString());
        double pickUpLocationLng =
            double.parse(dataSnapShot.value['pickup']['longitude'].toString());
        String pickUpAddress = dataSnapShot.value['pickup_address'].toString();

        double dropOffLocationLat =
            double.parse(dataSnapShot.value['dropoff']['latitude'].toString());
        double dropOffLocationLng =
            double.parse(dataSnapShot.value['dropoff']['longitude'].toString());
        String dropOffAddress =
            dataSnapShot.value['dropoff_address'].toString();
        String paymentMethod = dataSnapShot.value['payment_method'].toString();

        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickUpAddress;
        rideDetails.dropoff_address = dropOffAddress;
        rideDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
        rideDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method = paymentMethod;

        print("Information ::");
        print(rideDetails.pickup_address);
        print(rideDetails.dropoff_address);
      }
    });
  }
}
