// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../presentation/views/dashboard.dart';

class SignUpProvider extends ChangeNotifier {
  // Adjusting TextEditingControllers to match the screen requirements
  final TextEditingController firstNameTextController = TextEditingController();
  final TextEditingController lastNameTextController =
      TextEditingController(); // Added to match the screen
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController mobileTextController =
      TextEditingController(); // Added to match the screen
  bool isFormValid = false;
  bool isFirstNameValid = false;
  bool isLastNameValid = false;
  bool isEmailValid = false;
  bool isMobileValid = false;
  bool isPasswordValid = false;
  bool isSignupPage = true;
  bool isLoading = false;
  bool agreedToTerms = false;
  String? validateFirstName(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter your first name.';
    } else if (value!.length < 2) {
      return 'Your first name must be at least 2 characters long.';
    }
    return null; // Valid
  }

  String? validateLastName(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter your last name.';
    } else if (value!.length < 2) {
      return 'Your last name must be at least 2 characters long.';
    }
    return null; // Valid
  }

  String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter a valid email address.';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value!)) {
      return 'Please enter a valid email address format.';
    }
    return null; // Valid
  }

  String? validateMobile(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter your mobile number.';
    } else if (value!.length != 10) {
      return 'Your mobile number must be 10 digits long.';
    } else if (!RegExp(r"^[0-9]+$").hasMatch(value!)) {
      return 'Please enter a valid mobile number (numbers only).';
    }
    return null; // Valid
  }

  String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter a password.';
    } else if (value!.length < 8) {
      return 'Your password must be at least 8 characters long.';
    }
    return null; // Valid
  }

  void updateFormValidity() {
    isFormValid = isFirstNameValid &&
        isLastNameValid &&
        isEmailValid &&
        isMobileValid &&
        isPasswordValid &&
        agreedToTerms;
    notifyListeners();
  }

  void updateAgreedToTerms(bool? value) {
    agreedToTerms = value ?? false; // Set to false if value is null
    notifyListeners();
  }

  Future<void> signUpWithEmailAndPassword(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );
      String uid = userCredential.user!.uid;
      // Saving user data with additional fields as per the screen requirements
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': emailTextController.text.trim(),
        'first_name': firstNameTextController.text.trim(),
        'last_name': lastNameTextController.text.trim(), // Added last name
        'mobile': mobileTextController.text.trim(), // Added mobile
      });

      // Saving user ID and first name locally
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('userId', uid);
      await preferences.setString(
          'firstName', firstNameTextController.text.trim());

      isSignupPage = !isSignupPage;
      notifyListeners();
      // Navigate to the next screen or show success message
    } catch (e) {
      _handleError(context, e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithEmailAndPassword(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );
      String uid = userCredential.user!.uid;
      String firstName = await fetchFirstName(uid);

      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('userId', uid);
      await preferences.setString('firstName', firstName);

      // Navigate to the next screen or show success message
    } catch (e) {
      _handleError(context, e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> fetchFirstName(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(uid).get();
    if (documentSnapshot.exists) {
      return (documentSnapshot.data() as Map<String, dynamic>)['first_name'];
    } else {
      throw Exception('Document does not exist in the database');
    }
  }

  void toggleSignupScreen() {
    isSignupPage = !isSignupPage;
    notifyListeners();
  }

  void _handleError(BuildContext context, Object e) {
    String errorMessage = 'An error occurred. Please try again.';
    if (e is FirebaseAuthException) {
      errorMessage = e.message ?? errorMessage;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }
}
