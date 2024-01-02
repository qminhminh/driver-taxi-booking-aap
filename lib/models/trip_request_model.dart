import 'dart:convert';

class TripRequest {
  final String id;
  final String tripID;
  final String publishDateTime;
  final String userName;
  final String userPhone;
  final String userID;
  final Map<String, String> pickUpLatLng;
  final Map<String, String> dropOffLatLng;
  final String pickUpAddress;
  final String dropOffAddress;
  final String driverID;
  final Map<String, String> carDetails;
  final Map<String, String> driverLocation;
  final String driverName;
  final String driverPhone;
  final String driverPhoto;
  final String fareAmount;
  final String status;
  final double ratings;

  TripRequest({
    required this.id,
    required this.tripID,
    required this.publishDateTime,
    required this.userName,
    required this.userPhone,
    required this.userID,
    required this.pickUpLatLng,
    required this.dropOffLatLng,
    required this.pickUpAddress,
    required this.dropOffAddress,
    required this.driverID,
    required this.carDetails,
    required this.driverLocation,
    required this.driverName,
    required this.driverPhone,
    required this.driverPhoto,
    required this.fareAmount,
    required this.status,
    required this.ratings,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripID': tripID,
      'publishDateTime': publishDateTime,
      'userName': userName,
      'userPhone': userPhone,
      'userID': userID,
      'pickUpLatLng': pickUpLatLng,
      'dropOffLatLng': dropOffLatLng,
      'driverID': driverID,
      'carDetails': carDetails,
      'driverLocation': driverLocation,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'driverPhoto': driverPhoto,
      'fareAmount': fareAmount,
      'status': status,
      'ratings': ratings,
    };
  }

  factory TripRequest.fromMap(Map<String, dynamic> map) {
    return TripRequest(
      id: map['_id'] ?? '',
      tripID: map['tripID'] ?? '',
      publishDateTime: map['publishDateTime'] ?? '',
      userName: map['userName'] ?? '',
      userPhone: map['userPhone'] ?? '',
      userID: map['userID'] ?? '',
      pickUpLatLng: Map<String, String>.from(map['pickUpLatLng'] ?? {}),
      dropOffLatLng: Map<String, String>.from(map['dropOffLatLng'] ?? {}),
      pickUpAddress: map['pickUpAddress'] ?? '',
      dropOffAddress: map['dropOffAddress'] ?? '',
      driverID: map['driverID'] ?? '',
      carDetails: Map<String, String>.from(map['carDetails'] ?? {}),
      driverLocation: Map<String, String>.from(map['driverLocation'] ?? {}),
      driverName: map['driverName'] ?? '',
      driverPhone: map['driverPhone'] ?? '',
      driverPhoto: map['driverPhoto'] ?? '',
      fareAmount: map['fareAmount'] ?? '',
      status: map['status'] ?? 'new',
      ratings: (map['ratings'] ?? 0).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TripRequest.fromJson(String source) =>
      TripRequest.fromMap(json.decode(source));
}
