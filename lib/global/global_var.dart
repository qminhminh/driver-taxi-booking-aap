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
    "key=AAAAhlM0HqE:APA91bHwwKJ8IaWSKjuJlu_1ZTAp5c9bw9i7Vavn9zZsmol3rgF51cg6Cs8r-np2bKuZBGRsh-PeHpVDI6STAdamKMToy_gFfGY5oqybSJIIWi81iws1aAxpYbqWtaBCGHQqNg_raMMF";

Position? driverCurrentPosition;

String driverName = "";
String driverPhone = "";
String driverPhoto = "";
String carColor = "";
String carModel = "";
String carNumber = "";
