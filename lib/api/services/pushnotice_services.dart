// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:driver_taxi_booking_app/constants/error_handing.dart';
import 'package:driver_taxi_booking_app/constants/global_variables.dart';
import 'package:driver_taxi_booking_app/constants/utils.dart';
import 'package:driver_taxi_booking_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PushNoticeServices {
  double? pickUpLat;
  double? pickUpLng;
  String? pickupAddress;
  double? dropOffLat;
  double? dropOffLng;
  String? dropOffAddress;
  String? userName;
  String? userPhone;

  // get trip request using id
  getTripRequest({
    required BuildContext context,
    required String tripId,
  }) async {
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/users/get-trip-request/driver'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
        body: jsonEncode({
          'tripId': tripId,
        }),
      );

      print(res.body);

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            try {
              dynamic data = jsonDecode(res.body);
              pickUpLat = data["pickUpLatLng"]["latitude"];
              pickUpLng = data["pickUpLatLng"]["longitude"];
              pickupAddress = data["pickUpAddress"];
              dropOffLat = data["dropOffLatLng"]["latitude"];
              dropOffLng = data["dropOffLatLng"]["longitude"];
              userName = data["userName"];
              dropOffLng = data["userPhone"];

              showSnackBar(context, pickUpLat.toString());
              showSnackBar(context, pickUpLng.toString());
              showSnackBar(context, dropOffLat.toString());
              showSnackBar(context, dropOffLng.toString());
            } catch (e) {
              showSnackBar(context, e.toString());
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
