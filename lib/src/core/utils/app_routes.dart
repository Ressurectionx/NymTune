import 'package:flutter/material.dart';
import 'package:nymtune/src/presentation/presentation/views/dashboard.dart';
import 'package:nymtune/src/presentation/presentation/views/home_view.dart';
import 'package:nymtune/src/presentation/presentation/views/setting.dart';
import 'package:nymtune/src/presentation/presentation/views/signup_view.dart';

class AppRoutes {
  // Define your named routes here
  static const String dashboard = '/';
  static const String signUp = '/signup';

  static const String homeRoute = '/home';
  static const String settingsRoute = '/settings';
  static const String profileRoute = '/profile';

  static Map<String, WidgetBuilder> get routes => {
        dashboard: (context) => const DashboardView(),

        signUp: (context) => const SignUpView(),

        homeRoute: (context) => const HomeView(),
        settingsRoute: (context) => const Setting(),
        // profileRoute: (context) => ProfileScreen(),
      };
}
