// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EarningsPage extends StatefulWidget {
  static const String routeName = '/earning';
  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  String driverEarnings = "";

  getTotalEarningsOfCurrentDriver() async {
    DatabaseReference driversRef =
        FirebaseDatabase.instance.ref().child("drivers");

    await driversRef
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((snap) {
      if ((snap.snapshot.value as Map)["earnings"] != null) {
        setState(() {
          driverEarnings =
              ((snap.snapshot.value as Map)["earnings"]).toString();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getTotalEarningsOfCurrentDriver();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: Colors.green[300],
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/totalearnings.png",
                      width: 150,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Total Earnings:",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "\$ " + driverEarnings,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
