import 'dart:convert';

import 'package:driver_taxi_booking_app/models/rating_model.dart';

class User {
  final String id;
  final String blockStatus;
  final String carColor;
  final String carModel;
  final String carNumber;
  final String deviceToken;
  final String token;
  final String email;
  final String password;
  final String name;
  final String newTripStatus;
  final String phone;
  final String photo;
  final String idf;
  final String earnings;
  final List<Rating> ratings;

  User({
    required this.id,
    required this.blockStatus,
    required this.carColor,
    required this.carModel,
    required this.carNumber,
    required this.deviceToken,
    required this.token,
    required this.email,
    required this.password,
    required this.name,
    required this.newTripStatus,
    required this.phone,
    required this.photo,
    required this.idf,
    required this.earnings,
    required this.ratings,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'blockStatus': blockStatus,
      'carColor': carColor,
      'carModel': carModel,
      'carNumber': carNumber,
      'deviceToken': deviceToken,
      'token': token,
      'email': email,
      'password': password,
      'name': name,
      'newTripStatus': newTripStatus,
      'phone': phone,
      'photo': photo,
      'idf': idf,
      'earnings': earnings,
      'ratings': ratings,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      blockStatus: map['blockStatus'] ?? '',
      carColor: map['carColor'] ?? '',
      carModel: map['carModel'] ?? '',
      carNumber: map['carNumber'] ?? '',
      deviceToken: map['deviceToken'] ?? '',
      token: map['token'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      name: map['name'] ?? '',
      newTripStatus: map['newTripStatus'] ?? '',
      phone: map['phone'] ?? '',
      photo: map['photo'] ?? '',
      idf: map['idf'] ?? '',
      earnings: map['earnings'] ?? '',
      ratings: (map['ratings'] as List<dynamic>?)
              ?.map((rating) => Rating.fromMap(rating))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? blockStatus,
    String? carColor,
    String? carModel,
    String? carNumber,
    String? email,
    String? deviceToken,
    String? token,
    String? password,
    String? name,
    String? newTripStatus,
    String? phone,
    String? photo,
    String? idf,
    String? earnings,
    List<Rating>? ratings,
  }) {
    return User(
      id: id ?? this.id,
      blockStatus: blockStatus ?? this.blockStatus,
      carColor: carColor ?? this.carColor,
      carModel: carModel ?? this.carModel,
      carNumber: carNumber ?? this.carNumber,
      deviceToken: deviceToken ?? this.deviceToken,
      token: token ?? this.token,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      newTripStatus: newTripStatus ?? this.newTripStatus,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      idf: idf ?? this.idf,
      earnings: earnings ?? this.earnings,
      ratings: ratings ?? [],
    );
  }
}
