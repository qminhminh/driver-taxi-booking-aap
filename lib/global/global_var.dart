import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String userName = "";

String googleMapKey = "AIzaSyDuDxriw8CH8NbVLiXtKFQ2Nb64AoRSdyg";

const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

StreamSubscription<Position>? positionStreamHomePage;
StreamSubscription<Position>? positionStreamNewTripPage;

int driverTripRequestTimeout = 20;

final audioPlayer = AssetsAudioPlayer();
String serverKeyFCM =
    "key=AAAAOtdJJgY:APA91bH-Z6QUvSjLyib3NOQz6Cd9un5n_hc1V-sieT7Sll-BlvUYuax2ZJ0IANKVDuRwV0BCB-5tajde4f4NXGNybT7t8YfGbKxSeI4WXGInBiVAH4jqEAcVlk2tRxgZ-3hFYeTIxkCp";

Position? driverCurrentPosition;

String driverName = "";
String driverPhone = "";
String driverPhoto = "";
String carColor = "";
String carModel = "";
String carNumber = "";
