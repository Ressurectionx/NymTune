import 'package:flutter/material.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';

import '../../../core/theme/input_decoration.dart';

class HWSearchBar extends StatelessWidget {
  const HWSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: inputDecoration(),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.dark3(),
              child: const Icon(
                Icons.loop_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
