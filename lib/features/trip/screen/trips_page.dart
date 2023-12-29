// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'package:driver_taxi_booking_app/features/trip/screen/trips_history_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TripsPage extends StatefulWidget {
  static const String routeName = '/trip-page';
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  String currentDriverTotalTripsCompleted = "";

  getCurrentDriverTotalNumberOfTripsCompleted() async {
    DatabaseReference tripRequestsRef =
        FirebaseDatabase.instance.ref().child("tripRequests");

    await tripRequestsRef.once().then((snap) async {
      if (snap.snapshot.value != null) {
        Map<dynamic, dynamic> allTripsMap = snap.snapshot.value as Map;
        int allTripsLength = allTripsMap.length;

        List<String> tripsCompletedByCurrentDriver = [];

        allTripsMap.forEach((key, value) {
          if (value["status"] != null) {
            if (value["status"] == "ended") {
              if (value["driverID"] == FirebaseAuth.instance.currentUser!.uid) {
                tripsCompletedByCurrentDriver.add(key);
              }
            }
          }
        });

        setState(() {
          currentDriverTotalTripsCompleted =
              tripsCompletedByCurrentDriver.length.toString();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getCurrentDriverTotalNumberOfTripsCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Total Trips
          Center(
            child: Container(
              color: Colors.green[300],
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/totaltrips.png",
                      width: 190,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Total Trips:",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      currentDriverTotalTripsCompleted,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          //check trip history
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => TripsHistoryPage()));
            },
            child: Center(
              child: Container(
                color: Colors.green[300],
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/tripscompleted.png",
                        width: 190,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Check Trips History",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
