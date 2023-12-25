// ignore_for_file: use_build_context_synchronously, avoid_print, void_checks

import 'dart:convert';

import 'package:driver_taxi_booking_app/constants/error_handing.dart';
import 'package:driver_taxi_booking_app/constants/global_variables.dart';
import 'package:driver_taxi_booking_app/constants/utils.dart';
import 'package:driver_taxi_booking_app/providers/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeService {
  double? lat;
  double? long;
  FirebaseMessaging firebaseCloudMessaging = FirebaseMessaging.instance;

  // update and save geofire
  void updateAndsavegeofire({
    required BuildContext context,
    required String uid,
    required double latitude,
    required double longtitude,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/users/online-trip/status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          'email': userprovider.user.email,
          'idm': userprovider.user.id,
          'idf': uid,
          'latitude': latitude,
          'longtitude': longtitude
        }),
      );

      httpErrorHandle(response: res, context: context, onSuccess: () {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

// update long anf lat
  updateLongandLat({
    required BuildContext context,
    required String uid,
    required double latitude,
    required double longtitude,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.put(
        Uri.parse('$uri/api/users/update-online-trip/status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          'email': userprovider.user.email,
          'idm': userprovider.user.id,
          'idf': uid,
          'latitude': latitude,
          'longtitude': longtitude
        }),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            try {
              dynamic data = jsonDecode(res.body);
              lat = data['lattitude'];
              long = data['longtitude'];
            } catch (e) {
              showSnackBar(context, 'Error parsing JSON: $e');
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

// delete geofire driver online
  void deleteGeofireDriverOnline({
    required BuildContext context,
    required String idf,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.delete(
        Uri.parse('$uri/api/users/delete-online-trip/status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          'idm': userprovider.user.id,
          'idf': idf,
          'email': userprovider.user.email,
        }),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Offline Successfull");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

// update drivce token
  upatedeviceToken({
    required BuildContext context,
  }) async {
    try {
      String? deviceRecognitionToken = await firebaseCloudMessaging.getToken();
      final userprovider = Provider.of<UserProvider>(context, listen: false);
      http.Response res =
          await http.put(Uri.parse('$uri/api/users/update-tokendevice/driver'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userprovider.user.token
              },
              body: jsonEncode({
                'email': userprovider.user.email,
                'devicetoken': deviceRecognitionToken,
              }));

      print(res.body);

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Update device token');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

// remove location driver
  void removeLocationDriver({
    required BuildContext context,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.delete(
        Uri.parse('$uri/api/users/remove-location/driver'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          'idm': userprovider.user.id,
        }),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Successfull");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
