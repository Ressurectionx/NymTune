import 'package:flutter/material.dart';
import 'package:nymtune/src/core/theme/app_text_styles.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Future Function() onTap;
  final bool? margin;
  final bool
      disable; // Changed to non-nullable to ensure a value is always provided.
  final bool isLoading; // Added to control loading state.

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.margin = true,
    this.disable = false,
    this.isLoading = false, // Default value is false.
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (disable || isLoading) return; // Check isLoading as well.
        await onTap();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: margin! ? 20 : 0),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: disable
                ? [
                    AppColors.greenYellow().withOpacity(0.3),
                    AppColors.greenYellow().withOpacity(0.3),
                  ]
                : [
                    AppColors.greenYellow().withOpacity(0.9),
                    AppColors.greenYellow().withOpacity(0.7),
                    AppColors.greenYellow().withOpacity(0.6),
                    AppColors.greenYellow().withOpacity(0.7),
                    AppColors.greenYellow().withOpacity(0.9)
                  ],
          ),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                ),
              )
            : Center(
                child: Text(text, style: AppTextStyles.subHeader),
              ),
      ),
    );
  }
}
