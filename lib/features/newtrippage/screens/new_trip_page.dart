// ignore_for_file: must_be_immutable

import 'package:driver_taxi_booking_app/models/trip_details.dart';
import 'package:flutter/material.dart';

class NewTripPage extends StatefulWidget {
  TripDetails? newTripDetailsInfo;

  NewTripPage({
    super.key,
    this.newTripDetailsInfo,
  });

  @override
  State<NewTripPage> createState() => _NewTripPageState();
}

class _NewTripPageState extends State<NewTripPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
