import 'package:flutter/material.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/presentation/providers/song_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../providers/signup_providers.dart';

class HWHeader extends StatelessWidget {
  const HWHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Consumer<SignUpProvider>(
        builder: (context, provider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Missed you,",
                      style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                    TextSpan(
                      text:
                          "\n${provider.userName}", // Access username directly
                      style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontSize: 20,
                          fontFamily: "Michroma"),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.dark3(),
                child: const Icon(Icons.person),
              )
            ],
          );
        },
      ),
    );
  }
}
