import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nymtune/src/core/theme/app_text_styles.dart';

import 'app_colors.dart';

InputDecoration inputDecoration() {
  return InputDecoration(
    prefixIcon: const Icon(
      CupertinoIcons.search_circle_fill,
      color: Colors.white30,
      size: 30,
    ),
    labelStyle: AppTextStyles.subtitle,
    filled: true,
    hintText: "Search",
    hintStyle: AppTextStyles.subtitle,
    fillColor: AppColors.dark3(),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.black),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.black),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.black),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.black),
    ),
  );
}
