import 'dart:convert';

class CarModel {
  final String id;
  final String carColor;
  final String carModel;
  final String carNumber;

  CarModel({
    required this.id,
    required this.carColor,
    required this.carModel,
    required this.carNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carColor': carColor,
      'carModel': carModel,
      'carNumber': carNumber,
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['_id'] ?? '',
      carColor: map['carColor'] ?? '',
      carModel: map['carModel'] ?? '',
      carNumber: map['carNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CarModel.fromJson(String source) =>
      CarModel.fromMap(json.decode(source));

  CarModel copyWith({
    String? id,
    String? carColor,
    String? carModel,
    String? carNumber,
  }) {
    return CarModel(
      id: id ?? this.id,
      carColor: carColor ?? this.carColor,
      carModel: carModel ?? this.carModel,
      carNumber: carNumber ?? this.carNumber,
    );
  }
}
