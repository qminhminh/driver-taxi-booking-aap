// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:driver_taxi_booking_app/global/global_var.dart';
import 'package:driver_taxi_booking_app/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  static sendNotificationToSelectedDriver(
      String deviceToken, BuildContext context, String idf) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);

    Map<String, String> headerNotificationMap = {
      "Content-Type": "application/json",
      "Authorization": serverKeyFCM,
    };

    Map titleBodyNotificationMap = {
      "title": "${userprovider.user.name} is calling you",
      "body": "Incoming video call",
    };

    Map dataMapNotification = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "idf": idf,
    };

    List<Map<String, dynamic>> actions = [
      {
        "action": "accept", // Hành động khi nút được nhấn
        "title": "Accept", // Tiêu đề của nút
      },
      {
        "action": "reject",
        "title": "Reject",
      },
    ];

    Map bodyNotificationMap = {
      "notification": titleBodyNotificationMap,
      "data": dataMapNotification,
      "priority": "high",
      "to": deviceToken,
      "actions": actions,
    };

    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotificationMap,
      body: jsonEncode(bodyNotificationMap),
    );
  }
}
