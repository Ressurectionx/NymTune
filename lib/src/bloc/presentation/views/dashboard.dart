import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lottie/lottie.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';

import 'home_view.dart';
import 'setting.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  bool showSetting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [HomeView(), Setting()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GlassmorphicContainer(
        width: MediaQuery.of(context).size.width,
        height: 75,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        borderRadius: 24,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1)
          ],
        ),
        border: 2,
        blur: 10,
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.dark2(),
            AppColors.dark3(),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.greenYellow(),
                    child: Lottie.asset("assets/images/music.json"),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: showSetting
                        ? Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Lottie.asset(
                              controller: _controller,
                              "assets/images/search.json",
                            ))
                        : const Icon(size: 22, Icons.search),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: showSetting
                        ? Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Lottie.asset(
                                height: 25,
                                controller: _controller,
                                "assets/images/setting.json"),
                          )
                        : const Icon(size: 22, Icons.settings),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
