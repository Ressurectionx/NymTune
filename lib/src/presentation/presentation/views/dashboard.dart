import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lottie/lottie.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/presentation/presentation/views/search_view.dart';
import 'package:nymtune/src/presentation/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';

import 'home_view.dart';
import 'setting.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: dashboardProvider.currentIndex,
        children: const [
          HomeView(),
          SearchView(),
          Setting(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildFloatingActionButton(dashboardProvider),
    );
  }

  Widget buildFloatingActionButton(DashboardProvider dashboardProvider) {
    return GlassmorphicContainer(
      width: MediaQuery.of(context).size.width,
      height: 75,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      borderRadius: 24,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      ),
      border: 2,
      blur: 10,
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.dark2(), AppColors.dark3()],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildIcon(dashboardProvider, 0, Icons.music_note,
                  "assets/images/music.json"),
              buildIcon(dashboardProvider, 1, Icons.search,
                  "assets/images/search.json"),
              buildIcon(dashboardProvider, 2, Icons.settings,
                  "assets/images/setting.json"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIcon(DashboardProvider dashboardProvider, int index,
      IconData icon, String lottieAsset) {
    bool isCurrentIndex = dashboardProvider.currentIndex == index;
    return GestureDetector(
      onTap: () => dashboardProvider.setCurrentIndex(index),
      child: CircleAvatar(
        radius: isCurrentIndex ? 30 : 20,
        backgroundColor:
            isCurrentIndex ? AppColors.greenYellow() : Colors.black,
        child: isCurrentIndex
            ? Lottie.asset(lottieAsset,
                height: dashboardProvider.currentIndex == 0
                    ? 60
                    : (dashboardProvider.currentIndex == 1 ? 50 : 45),
                repeat: true)
            : Icon(icon, size: 22),
      ),
    );
  }
}
