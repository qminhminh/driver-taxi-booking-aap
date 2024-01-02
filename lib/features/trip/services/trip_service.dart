// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:driver_taxi_booking_app/constants/error_handing.dart';
import 'package:driver_taxi_booking_app/constants/global_variables.dart';
import 'package:driver_taxi_booking_app/constants/utils.dart';
import 'package:driver_taxi_booking_app/models/rating_model.dart';
import 'package:driver_taxi_booking_app/models/trip_request_model.dart';
import 'package:driver_taxi_booking_app/providers/user_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class TripRequestService {
  Future<List<TripRequest>> getAllTripRequest(
    BuildContext context,
  ) async {
    List<TripRequest> list = [];
    try {
      final userprovider = Provider.of<UserProvider>(context, listen: false);
      http.Response res = await http.post(
        Uri.parse('$uri/api/users/get-all-trip-request/driver'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token,
        },
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              list.add(
                  TripRequest.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return list;
  }

  // get all rating
  Future<double> getRatingAVG(BuildContext context) async {
    double totalRating = 0;
    double avgRating = 0;
    final userprovider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/users/get-all-star/driver/${userprovider.user.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userprovider.user.token
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Assuming the response body is a list of ratings for the specific driver
          List<Rating> ratings = [];
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            ratings.add(Rating.fromMap(jsonDecode(res.body)[i]));
          }

          // Calculate totalRating
          for (int j = 0; j < ratings.length; j++) {
            totalRating += ratings[j].rating;
          }

          // Calculate avgRating
          if (ratings.isNotEmpty) {
            avgRating = totalRating / ratings.length;
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return avgRating;
  }
}
