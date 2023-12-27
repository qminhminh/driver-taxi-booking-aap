// ignore_for_file: must_be_immutable, prefer_collection_literals, use_build_context_synchronously, prefer_const_constructors, unused_local_variable, avoid_function_literals_in_foreach_calls, prefer_if_null_operators, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:driver_taxi_booking_app/api/pushNotification/push_notification_service.dart';
import 'package:driver_taxi_booking_app/common/methods/common_methods.dart';
import 'package:driver_taxi_booking_app/common/methods/map_theme_methods.dart';
import 'package:driver_taxi_booking_app/features/callpages/call_page_zego.dart';
import 'package:driver_taxi_booking_app/features/home/services/home_services.dart';
import 'package:driver_taxi_booking_app/features/newtrippage/services/new_trip_service.dart';
import 'package:driver_taxi_booking_app/global/global_var.dart';
import 'package:driver_taxi_booking_app/models/trip_details.dart';
import 'package:driver_taxi_booking_app/widgets/loading_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  MapThemeMethods themeMethods = MapThemeMethods();
  double googleMapPaddingFromBottom = 0;
  List<LatLng> coordinatesPolylineLatLngList = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Marker> markersSet = Set<Marker>();
  Set<Circle> circlesSet = Set<Circle>();
  Set<Polyline> polyLinesSet = Set<Polyline>();
  BitmapDescriptor? carMarkerIcon;
  final NewTripService newTripService = NewTripService();
  final HomeService homeService = HomeService();
  bool directionRequested = false;
  String statusOfTrip = "accepted";
  String durationText = "", distanceText = "";
  String buttonTitleText = "ARRIVED";
  Color buttonColor = Colors.indigoAccent;

  // image
  makeMarker() {
    if (carMarkerIcon == null) {
      ImageConfiguration configuration =
          createLocalImageConfiguration(context, size: Size(2, 2));

      BitmapDescriptor.fromAssetImage(
              configuration, "assets/images/tracking.png")
          .then((valueIcon) {
        carMarkerIcon = valueIcon;
      });
    }
  }

  // draw route and poly line and marker and circle
  obtainDirectionAndDrawRoute(
      sourceLocationLatLng, destinationLocationLatLng) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LoadingDialog(
              messageText: 'Please wait...',
            ));

    // get direction details
    var tripDetailsInfo = await CommonMethods.getDirectionDetailsFromAPI(
        sourceLocationLatLng, destinationLocationLatLng);

    Navigator.pop(context);

    PolylinePoints pointsPolyline = PolylinePoints();
    // add position in list
    List<PointLatLng> latLngPoints =
        pointsPolyline.decodePolyline(tripDetailsInfo!.encodedPoints!);

    coordinatesPolylineLatLngList.clear();

    // check is not emty
    if (latLngPoints.isNotEmpty) {
      latLngPoints.forEach((PointLatLng pointLatLng) {
        coordinatesPolylineLatLngList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    //draw polyline
    polyLinesSet.clear();

    setState(() {
      Polyline polyline = Polyline(
          polylineId: const PolylineId("routeID"),
          color: Colors.amber,
          points: coordinatesPolylineLatLngList,
          jointType: JointType.round,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);

      polyLinesSet.add(polyline);
    });

    //fit the polyline on google map
    LatLngBounds boundsLatLng;

    if (sourceLocationLatLng.latitude > destinationLocationLatLng.latitude &&
        sourceLocationLatLng.longitude > destinationLocationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: destinationLocationLatLng,
        northeast: sourceLocationLatLng,
      );
    } else if (sourceLocationLatLng.longitude >
        destinationLocationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(
            sourceLocationLatLng.latitude, destinationLocationLatLng.longitude),
        northeast: LatLng(
            destinationLocationLatLng.latitude, sourceLocationLatLng.longitude),
      );
    } else if (sourceLocationLatLng.latitude >
        destinationLocationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(
            destinationLocationLatLng.latitude, sourceLocationLatLng.longitude),
        northeast: LatLng(
            sourceLocationLatLng.latitude, destinationLocationLatLng.longitude),
      );
    } else {
      boundsLatLng = LatLngBounds(
        southwest: sourceLocationLatLng,
        northeast: destinationLocationLatLng,
      );
    }

    controllerGoogleMap!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 72));

    //add marker driver
    Marker sourceMarker = Marker(
      markerId: const MarkerId('sourceID'),
      position: sourceLocationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    //add marker customer
    Marker destinationMarker = Marker(
      markerId: const MarkerId('destinationID'),
      position: destinationLocationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    setState(() {
      markersSet.add(sourceMarker);
      markersSet.add(destinationMarker);
    });

    //add circle driver
    Circle sourceCircle = Circle(
      circleId: const CircleId('sourceCircleID'),
      strokeColor: Colors.orange,
      strokeWidth: 4,
      radius: 14,
      center: sourceLocationLatLng,
      fillColor: Colors.green,
    );

    //add circle driver
    Circle destinationCircle = Circle(
      circleId: const CircleId('destinationCircleID'),
      strokeColor: Colors.green,
      strokeWidth: 4,
      radius: 14,
      center: destinationLocationLatLng,
      fillColor: Colors.orange,
    );

    setState(() {
      circlesSet.add(sourceCircle);
      circlesSet.add(destinationCircle);
    });
  }

  // get location driver and marker camera driver
  getLiveLocationUpdatesOfDriver() {
    LatLng lastPositionLatLng = LatLng(0, 0);

    positionStreamNewTripPage =
        Geolocator.getPositionStream().listen((Position positionDriver) {
      driverCurrentPosition = positionDriver;

      LatLng driverCurrentPositionLatLng = LatLng(
          homeService.lat != null
              ? homeService.lat!
              : driverCurrentPosition!.latitude,
          homeService.long != null
              ? homeService.long!
              : driverCurrentPosition!.longitude);

      Marker carMarker = Marker(
        markerId: const MarkerId("carMarkerID"),
        position: driverCurrentPositionLatLng,
        icon: carMarkerIcon!,
        infoWindow: const InfoWindow(title: "My Location"),
      );

      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: driverCurrentPositionLatLng, zoom: 16);
        controllerGoogleMap!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markersSet
            .removeWhere((element) => element.markerId.value == "carMarkerID");
        markersSet.add(carMarker);
      });

      lastPositionLatLng = driverCurrentPositionLatLng;

      //update Trip Details Information
      updateTripDetailsInformation();

      //update driver location to tripRequest
      Map updatedLocationOfDriver = {
        "latitude": homeService.lat != null
            ? homeService.lat
            : driverCurrentPosition!.latitude,
        "longitude": homeService.long != null
            ? homeService.long
            : driverCurrentPosition!.longitude,
      };

      // update lat and long firebase
      FirebaseDatabase.instance
          .ref()
          .child("tripRequests")
          .child(widget.newTripDetailsInfo!.tripID!)
          .child("driverLocation")
          .set(updatedLocationOfDriver);

      // update lat nad long driver mongo
      newTripService.updateTripDriverLocation(
          context: context,
          tripId: widget.newTripDetailsInfo!.tripID!.toString(),
          latitude: homeService.lat != null
              ? homeService.lat.toString()
              : driverCurrentPosition!.latitude.toString(),
          longitude: homeService.long != null
              ? homeService.long.toString()
              : driverCurrentPosition!.longitude.toString());
    });
  }

  // update trip detail infomation
  updateTripDetailsInformation() async {
    if (!directionRequested) {
      directionRequested = true;

      if (driverCurrentPosition == null) {
        return;
      }

      var driverLocationLatLng = LatLng(
          driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

      LatLng dropOffDestinationLocationLatLng;
      if (statusOfTrip == "accepted") {
        dropOffDestinationLocationLatLng =
            widget.newTripDetailsInfo!.pickUpLatLng!;
      } else {
        dropOffDestinationLocationLatLng =
            widget.newTripDetailsInfo!.dropOffLatLng!;
      }

      var directionDetailsInfo = await CommonMethods.getDirectionDetailsFromAPI(
          driverLocationLatLng, dropOffDestinationLocationLatLng);

      if (directionDetailsInfo != null) {
        directionRequested = false;

        setState(() {
          durationText = directionDetailsInfo.durationTextString!;
          distanceText = directionDetailsInfo.distanceTextString!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    makeMarker();

    return Scaffold(
      body: Stack(
        children: [
          ///google map
          GoogleMap(
            padding: EdgeInsets.only(bottom: googleMapPaddingFromBottom),
            mapType: MapType.hybrid,
            myLocationEnabled: true,
            markers: markersSet,
            circles: circlesSet,
            polylines: polyLinesSet,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController) async {
              controllerGoogleMap = mapController;
              themeMethods.updateMapTheme(controllerGoogleMap!);
              googleMapCompleterController.complete(controllerGoogleMap);

              setState(() {
                googleMapPaddingFromBottom = 262;
              });

              var driverCurrentLocationLatLng = LatLng(
                  homeService.lat != null
                      ? homeService.lat!
                      : driverCurrentPosition!.latitude,
                  homeService.long != null
                      ? homeService.long!
                      : driverCurrentPosition!.longitude);

              var userPickUpLocationLatLng =
                  widget.newTripDetailsInfo!.pickUpLatLng;

              await obtainDirectionAndDrawRoute(
                  driverCurrentLocationLatLng, userPickUpLocationLatLng);

              getLiveLocationUpdatesOfDriver();
            },
          ),

          ///trip details
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(17),
                    topLeft: Radius.circular(17)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 17,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              height: 256,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //trip duration
                    Center(
                      child: Text(
                        durationText + " - " + distanceText,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    //user name - call user icon btn
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //user name
                        Text(
                          widget.newTripDetailsInfo!.userName!,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        //call user icon btn
                        GestureDetector(
                          onTap: () {
                            launchUrl(
                              Uri.parse(
                                  "tel://${widget.newTripDetailsInfo!.userPhone.toString()}"),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        // vidoe call user icon btn
                        GestureDetector(
                          onTap: () {
                            DatabaseReference tokenOfCurrentDriverRef =
                                FirebaseDatabase.instance
                                    .ref()
                                    .child("users")
                                    .child(widget.newTripDetailsInfo!.userID!)
                                    .child("token");

                            tokenOfCurrentDriverRef
                                .once()
                                .then((dataSnapshot) async {
                              if (dataSnapshot.snapshot.value != null) {
                                String deviceToken =
                                    dataSnapshot.snapshot.value.toString();

                                //send notification

                                PushNotificationService
                                    .sendNotificationToSelectedDriver(
                                        deviceToken, context, deviceToken);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => CallPage(
                                            callID: deviceToken,
                                            name: widget
                                                .newTripDetailsInfo!.userName!,
                                            id: widget
                                                .newTripDetailsInfo!.userID!)));
                              } else {
                                return;
                              }
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.video_call,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        //chat user icon btn
                        GestureDetector(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.chat_sharp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    //pickup icon and location
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/initial.png",
                          height: 16,
                          width: 16,
                        ),
                        Expanded(
                          child: Text(
                            widget.newTripDetailsInfo!.pickupAddress.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    //dropoff icon and location
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/final.png",
                          height: 16,
                          width: 16,
                        ),
                        Expanded(
                          child: Text(
                            widget.newTripDetailsInfo!.dropOffAddress
                                .toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          //arrived button
                          if (statusOfTrip == "accepted") {
                            setState(() {
                              buttonTitleText = "START TRIP";
                              buttonColor = Colors.green;
                            });

                            statusOfTrip = "arrived";

                            // update status fire
                            FirebaseDatabase.instance
                                .ref()
                                .child("tripRequests")
                                .child(widget.newTripDetailsInfo!.tripID!)
                                .child("status")
                                .set("arrived");

                            // update status trip server
                            newTripService.updateStattusTripRequest(
                                context: context,
                                status: "arrived",
                                tripId: widget.newTripDetailsInfo!.tripID!);

                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) =>
                                    LoadingDialog(
                                      messageText: 'Please wait...',
                                    ));

                            await obtainDirectionAndDrawRoute(
                              widget.newTripDetailsInfo!.pickUpLatLng,
                              widget.newTripDetailsInfo!.dropOffLatLng,
                            );

                            Navigator.pop(context);
                          }
                          //start trip button
                          else if (statusOfTrip == "arrived") {
                            setState(() {
                              buttonTitleText = "END TRIP";
                              buttonColor = Colors.amber;
                            });

                            statusOfTrip = "ontrip";

                            // update trip status
                            FirebaseDatabase.instance
                                .ref()
                                .child("tripRequests")
                                .child(widget.newTripDetailsInfo!.tripID!)
                                .child("status")
                                .set("ontrip");

                            // update status trip
                            newTripService.updateStattusTripRequest(
                                context: context,
                                tripId: widget.newTripDetailsInfo!.tripID!,
                                status: "ontrip");
                          }
                          //end trip button
                          else if (statusOfTrip == "ontrip") {
                            //end the trip
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                        ),
                        child: Text(
                          buttonTitleText,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
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
