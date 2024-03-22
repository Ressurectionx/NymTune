import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/signup_providers.dart';
import '../widgets/dynamic_button.dart';
import '../widgets/dynamic_textfield.dart';
import '../widgets/terms_and_conditions.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpProvider(),
      child: Consumer<SignUpProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: const SizedBox(),
            ),
            body: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff1e1e1e), Colors.black])),
              child: Form(
                key: _formKey,
                onChanged: () {},
                child: provider.isSignupPage
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Sign Up",
                              style: AppTextStyles.header.copyWith(
                                color: AppColors.greenYellow(),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Column(
                              children: [
                                DynamicTextFields(
                                  text: "First name",
                                  controller: provider.firstNameTextController,
                                  validator: provider.validateFirstName,
                                ),
                                DynamicTextFields(
                                  text: "Last name",
                                  controller: provider.lastNameTextController,
                                  validator: provider.validateLastName,
                                ),
                                DynamicTextFields(
                                  text: 'Email',
                                  controller: provider.emailTextController,
                                  validator: provider.validateEmail,
                                ),
                                DynamicTextFields(
                                  text: 'Mobile',
                                  controller: provider.mobileTextController,
                                  validator: provider.validateMobile,
                                ),
                                DynamicTextFields(
                                  text: "Password",
                                  controller: provider.passwordTextController,
                                  validator: provider.validatePassword,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 44),
                          Text(
                            "Sign In",
                            style: AppTextStyles.header.copyWith(
                              color: AppColors.greenYellow(),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          DynamicTextFields(
                            text: "Email",
                            controller: provider.emailTextController,
                            validator: (value) {
                              provider.isEmailValid =
                                  value != null && value.isNotEmpty;
                              return null;
                            },
                          ),
                          DynamicTextFields(
                            text: 'Password',
                            controller: provider.passwordTextController,
                            validator: (value) {
                              provider.isPasswordValid =
                                  value != null && value.isNotEmpty;
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            isLoading: provider.isLoading,
                            onTap: () async {
                              if (provider
                                  .passwordTextController.text.isNotEmpty) {
                                provider.loginWithEmailAndPassword(context);
                              }
                            },
                            text: "Login",
                            margin: false,
                          ),
                        ],
                      ),
              ),
            ),
            bottomNavigationBar: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (provider.isSignupPage) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          TermsAndCondition(
                            provider: provider,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          PrimaryButton(
                            isLoading: provider.isLoading,
                            onTap: () {
                              // Trigger form validation
                              if (_formKey.currentState!.validate() &&
                                  provider.agreedToTerms) {
                                return provider
                                    .signUpWithEmailAndPassword(context);
                              }
                              // If the form is not valid, do not proceed and let the user correct the errors
                              return Future.value();
                            },
                            text: "Sign Up",
                            margin: false,
                            disable: !provider.agreedToTerms,
                          ),
                        ],
                      ),
                    )
                  ],
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    onTap: () {
                      provider.toggleSignupScreen();
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 80,
                      child: Center(
                        child: !provider.isSignupPage
                            ? RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: ' Don\'t have an account?',
                                      style: AppTextStyles.description.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Sign Up',
                                      style: AppTextStyles.description.copyWith(
                                        fontSize: 16,
                                        color: AppColors.greenYellow(),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: ' Do you have an account?',
                                      style: AppTextStyles.description.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Sign In',
                                      style: AppTextStyles.description.copyWith(
                                        fontSize: 16,
                                        color: AppColors.greenYellow(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
