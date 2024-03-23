import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/core/theme/app_text_styles.dart';

import '../../providers/signup_providers.dart';

class TermsAndCondition extends StatefulWidget {
  final SignUpProvider provider;

  const TermsAndCondition({super.key, required this.provider});

  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  @override
  Widget build(BuildContext context) {
    final isWebviewLayout = MediaQuery.of(context).size.width > 400.0;
    return Row(
      crossAxisAlignment:
          isWebviewLayout ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: <Widget>[
        Checkbox(
          activeColor: AppColors.greenYellow(),
          value: widget.provider.agreedToTerms,
          onChanged: (bool? value) =>
              widget.provider.updateAgreedToTerms(value),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'By creating an account, I agree to the ',
                  style: AppTextStyles.description
                      .copyWith(color: Colors.white, fontSize: 12),
                ),
                TextSpan(
                  text: 'Terms of Use',
                  style: AppTextStyles.description.copyWith(
                    decoration: TextDecoration.underline,
                    color: AppColors.greenYellow(),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print('Terms of Use tapped');
                    },
                ),
                TextSpan(
                  text: ' and our ',
                  style: AppTextStyles.description
                      .copyWith(color: Colors.white, fontSize: 12),
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: AppTextStyles.description.copyWith(
                    color: AppColors.greenYellow(),
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print('Privacy Policy tapped');
                    },
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
