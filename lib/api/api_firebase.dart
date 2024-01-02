// ignore_for_file: avoid_print, body_might_complete_normally_catch_error

import 'dart:io';
import 'package:driver_taxi_booking_app/features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class APIs {
  final AuthSerVice authSerVice = AuthSerVice();
  String image = '';
  // Sign up user
  Future<void> uploadImageToStorage(
    imageFile,
    urlOfUploadedImage,
    emailController,
    passwordController,
    nameController,
    phoneController,
    carColorController,
    carModelController,
    carNumberController,
  ) async {
    String imageIDName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImage =
        FirebaseStorage.instance.ref().child("Images").child(imageIDName);

    UploadTask uploadTask = referenceImage.putFile(File(imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    urlOfUploadedImage = await snapshot.ref.getDownloadURL();
    image = urlOfUploadedImage;
    registerNewDriver(
      emailController,
      passwordController,
      nameController,
      phoneController,
      urlOfUploadedImage,
      carColorController,
      carModelController,
      carNumberController,
    );
  }

  registerNewDriver(
    emailController,
    passwordController,
    nameController,
    phoneController,
    urlOfUploadedImage,
    carColorController,
    carModelController,
    carNumberController,
  ) async {
    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
            .catchError((e) {
      print(e.toString());
    }))
        .user;
    //FirebaseMessaging firebaseCloudMessaging = FirebaseMessaging.instance;
    // String? deviceRecognitionToken = await firebaseCloudMessaging.getToken();

    DatabaseReference usersRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(userFirebase!.uid);

    Map driverCarInfo = {
      "carColor": carColorController.text.trim(),
      "carModel": carModelController.text.trim(),
      "carNumber": carNumberController.text.trim(),
    };

    Map driverDataMap = {
      "photo": urlOfUploadedImage,
      "car_details": driverCarInfo,
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };
    usersRef.set(driverDataMap);
  }

  // sign in user
  signInUser(emailController, passwordController, BuildContext context) async {
    final User? userFirebase = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
            .catchError((errorMsg) {
      print(errorMsg.toString());
    }))
        .user;

    if (userFirebase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(userFirebase.uid);
      usersRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
            //userName = (snap.snapshot.value as Map)["name"];
          } else {
            FirebaseAuth.instance.signOut();
            authSerVice.logOut(context);
          }
        } else {
          FirebaseAuth.instance.signOut();
          authSerVice.logOut(context);
        }
      });
    }
  }
}
