import 'package:flutter/material.dart';
import 'package:nymtune/src/presentation/presentation/views/dashboard.dart';
import 'package:nymtune/src/presentation/presentation/views/details_view.dart';
import 'package:nymtune/src/presentation/presentation/views/home_view.dart';
import 'package:nymtune/src/presentation/presentation/views/setting.dart';

class AppRoutes {
  // Define your named routes here
  static const String dashboardRoute = '/';
  static const String homeRoute = '/home';
  static const String settingsRoute = '/settings';
  static const String profileRoute = '/profile';
  static const String details = '/details';

  static Map<String, WidgetBuilder> get routes => {
        dashboardRoute: (context) => const DashboardScreen(),
        homeRoute: (context) => const HomeView(),
        settingsRoute: (context) => const Setting(),
        details: (context) => const DetailsView()
        // profileRoute: (context) => ProfileScreen(),
      };
}
