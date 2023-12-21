import 'package:driver_taxi_booking_app/features/auth/screens/auth_screen.dart';
import 'package:driver_taxi_booking_app/features/earning/screen/earnings_page.dart';
import 'package:driver_taxi_booking_app/features/home/screens/home_screen.dart';
import 'package:driver_taxi_booking_app/features/profile/screen/profile_page.dart';
import 'package:driver_taxi_booking_app/features/trip/screen/trips_page.dart';
import 'package:driver_taxi_booking_app/pages/dashboard.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRooute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreen());

    case HomeScreen.reouteName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomeScreen());

    case Dashboard.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const Dashboard());

    case TripsPage.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const TripsPage());

    case ProfilePage.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const ProfilePage());

    case EarningsPage.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const EarningsPage());

    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Scaffold(
                body: Center(child: Text('Screen does not exit!')),
              ));
  }
}
