// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:driver_taxi_booking_app/features/auth/services/auth_service.dart';
import 'package:driver_taxi_booking_app/global/global_var.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profilepage';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController carTextEditingController = TextEditingController();
  final AuthSerVice authSerVice = AuthSerVice();

  setDriverInfo() {
    setState(() {
      nameTextEditingController.text = driverName;
      phoneTextEditingController.text = driverPhone;
      emailTextEditingController.text =
          FirebaseAuth.instance.currentUser!.email.toString();
      carTextEditingController.text =
          carNumber + " - " + carColor + " - " + carModel;
    });
  }

  @override
  void initState() {
    super.initState();

    setDriverInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //image
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: NetworkImage(
                        driverPhoto,
                      ),
                    )),
              ),

              const SizedBox(
                height: 16,
              ),

              //driver name
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 8),
                child: TextField(
                  controller: nameTextEditingController,
                  textAlign: TextAlign.center,
                  enabled: false,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              //driver phone
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 4),
                child: TextField(
                  controller: phoneTextEditingController,
                  textAlign: TextAlign.center,
                  enabled: false,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.phone_android_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              //driver email
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 4),
                child: TextField(
                  controller: emailTextEditingController,
                  textAlign: TextAlign.center,
                  enabled: false,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              //driver car info
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 4),
                child: TextField(
                  controller: carTextEditingController,
                  textAlign: TextAlign.center,
                  enabled: false,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.drive_eta_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              //logout btn
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  authSerVice.logOut(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 18)),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
