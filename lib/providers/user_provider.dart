import 'package:driver_taxi_booking_app/models/user.dart';
import 'package:flutter/widgets.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    blockStatus: '',
    carColor: '',
    carModel: '',
    carNumber: '',
    deviceToken: '',
    token: '',
    email: '',
    password: '',
    name: '',
    newTripStatus: '',
    phone: '',
    photo: '',
    idf: '',
    earnings: '',
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
