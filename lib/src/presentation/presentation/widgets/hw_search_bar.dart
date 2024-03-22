import 'package:flutter/material.dart';
import 'package:nymtune/main.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/input_decoration.dart';
import '../../providers/dashboard_provider.dart';

class HWSearchBar extends StatelessWidget {
  const HWSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  dashboardProvider.setCurrentIndex(1);
                },
                child: IgnorePointer(
                  child: TextField(
                    readOnly: true,
                    decoration: inputDecoration(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          const NymTune()), // MyApp() is your app's root widget
                  (Route<dynamic> route) => false,
                );
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.dark3(),
                child: const Icon(
                  Icons.loop_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
