import 'package:flutter/material.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/core/theme/app_text_styles.dart';

class DynamicTextFields extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;

  const DynamicTextFields(
      {super.key,
      required this.text,
      required this.controller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: AppTextStyles.subtitle
              .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextFormField(
            controller: controller,
            style: AppTextStyles.title.copyWith(color: Colors.white),
            validator: validator,
            decoration: textDecorationTheme()),
        const SizedBox(height: 20),
      ],
    );
  }
}

InputDecoration textDecorationTheme() {
  BorderRadius radius = const BorderRadius.all(Radius.circular(12));
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: AppColors.greenYellow(), width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
    ),
    filled: true,

    fillColor: AppColors.dark3(),
    errorStyle: const TextStyle(
      color: Colors.redAccent,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    ),
    alignLabelWithHint: true,
    // isDense: true,
  );
}
