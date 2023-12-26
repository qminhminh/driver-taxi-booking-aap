// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:driver_taxi_booking_app/constants/error_handing.dart';
import 'package:driver_taxi_booking_app/constants/global_variables.dart';
import 'package:driver_taxi_booking_app/constants/utils.dart';
import 'package:driver_taxi_booking_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class NewTripService {
  // update new trip driverLocation
  void updateTripDriverLocation({
    required BuildContext context,
    required String tripId,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.put(
        Uri.parse('$uri/api/users/update-trip-location/driver'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          'tripID': tripId,
          'latitude': latitude,
          'longitude': longitude,
          'userName': userprovider.user.name,
          'userId': FirebaseAuth.instance.currentUser!.uid,
          "userPhone": userprovider.user.phone,
        }),
      );

      httpErrorHandle(response: res, context: context, onSuccess: () {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // update new trip request
  void updateStattusTripRequest({
    required BuildContext context,
    required String tripId,
    required String status,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.put(
        Uri.parse('$uri/api/users/update-status-trip-request/driver'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          'tripID': tripId,
          "status": status,
        }),
      );

      httpErrorHandle(response: res, context: context, onSuccess: () {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
