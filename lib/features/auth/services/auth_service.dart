// ignore_for_file: use_build_context_synchronously, avoid_print
import 'dart:convert';
import 'package:driver_taxi_booking_app/constants/error_handing.dart';
import 'package:driver_taxi_booking_app/constants/global_variables.dart';
import 'package:driver_taxi_booking_app/constants/utils.dart';
import 'package:driver_taxi_booking_app/features/home/screens/home_screen.dart';
import 'package:driver_taxi_booking_app/models/user.dart';
import 'package:driver_taxi_booking_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSerVice {
  // sign up user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String phone,
    required String photo,
    required String carColor,
    required String carModel,
    required String carNumber,
  }) async {
    try {
      User user = User(
        id: '',
        blockStatus: '',
        email: email,
        password: password,
        name: name,
        phone: phone,
        photo: photo,
        token: '',
        carColor: carColor,
        carModel: carModel,
        carNumber: carNumber,
        deviceToken: '',
        newTripStatus: '',
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/users/signup-drivers'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: user.toJson(),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, 'Account created! Login with the same credentials!');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // sign In user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res =
          await http.post(Uri.parse('$uri/api/users/signin-drivers'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(
                {
                  "email": email,
                  "password": password,
                },
              ));

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            // provider

            Provider.of<UserProvider>(context, listen: false).setUser(res.body);

            // change json
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['token']);

            // navigator

            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.reouteName, (route) => false);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(Uri.parse('$uri/tokenisvaliddriver'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(Uri.parse('$uri/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            });

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);

        print(userRes.body);
        print(userProvider);
        print(response);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
