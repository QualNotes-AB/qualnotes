import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';

class AuthFailure {
  final FirebaseAuthException exception;

  const AuthFailure(this.exception);

  void checkException() {
    if (exception.code == "auth/user-not-found") {
      snackbar(
        'Authentication failed.',
        'There is no account registered on this email',
      );
    } else if (exception.code == 'user-not-found' ||
        exception.code == 'wrong-password') {
      snackbar(
        'Authentication failed.',
        "Email and password don't match.\nCheck your email and password!",
      );
    } else if (exception.code == 'email-already-in-use') {
      snackbar(
        'Authentication failed.',
        'Account has already been created with this email!',
      );
    } else if (exception.code == 'account-exists-with-different-credential') {
      snackbar(
        'Account already created.',
        "Linking ${exception.credential!.providerId} with account...",
      );
    } else {
      snackbar('Something went wrong.', 'Check your internet connection');
      return;
    }
  }
}

void snackbar(String title, String text) {
  Get.snackbar(
    title,
    text,
    backgroundColor: Colors.red[400],
    colorText: AppColors.white,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.only(),
    borderRadius: 0,
    snackPosition: SnackPosition.BOTTOM,
  );
}
