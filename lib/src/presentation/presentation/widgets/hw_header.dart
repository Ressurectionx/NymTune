import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class HWHeader extends StatelessWidget {
  const HWHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
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
                  text: "\nRessurectionX",
                  style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 20,
                      fontFamily: "Michroma"),
                ),
              ],
            ),
          ),
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            backgroundImage: NetworkImage(
                "https://images-cdn.9gag.com/photo/adVQM02_700b.jpg"),
          )
        ],
      ),
    );
  }
}
