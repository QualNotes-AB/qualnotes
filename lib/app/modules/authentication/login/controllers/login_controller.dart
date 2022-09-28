import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/data/errors/auth_failure.dart';
import 'package:qualnote/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool animationStart = false.obs;
  RxBool animationContinue = false.obs;
  Color mainColor = AppColors.darkGreen;
  String email = '';
  String password = '';

  void setEmail(String value) {
    email = value.trim();
    validateEmail();
  }

  void setPassword(value) {
    password = value;
    validatePassword();
  }

  RxBool emailValid = true.obs;
  RxString emailErrorMessage = ''.obs;
  RxBool passwordValid = true.obs;
  RxString passwordErrorMessage = ''.obs;

  validateEmail() {
    email.isEmpty
        ? {
            emailValid.value = false,
            emailErrorMessage.value = 'Please enter your email',
          }
        : !email.isEmail
            ? {
                emailValid.value = false,
                emailErrorMessage.value = 'Incorrect e-mail format',
              }
            : emailValid.value = true;
  }

  validatePassword() {
    password.isEmpty
        ? {
            passwordValid.value = false,
            passwordErrorMessage.value = 'Please enter your password',
          }
        : passwordValid.value = true;
  }

  bool validateFields() {
    validateEmail();
    validatePassword();
    return (emailValid.value == false || passwordValid.value == false)
        ? false
        : true;
  }

  Future<void> signIn() async {
    try {
      if (validateFields()) {
        mainColor = AppColors.darkGreen;
        animationStart.value = true;
        animationContinue.value = false;

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        if (FirebaseAuth.instance.currentUser != null) {
          animationContinue.value = true;
          await Future.delayed(const Duration(milliseconds: 1100));
          Get.offAllNamed(Routes.HOME);
          resetFields();
        }
      }
    } on FirebaseAuthException catch (e) {
      animationContinue.value = true;
      await Future.delayed(const Duration(milliseconds: 1500));
      AuthFailure(e).checkException();
    }
  }

  Future<void> signInWithGoogle() async {
    mainColor = AppColors.darkBlue;
    animationStart.value = true;
    animationContinue.value = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;

        if (googleAuth != null) {
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);

            if (FirebaseAuth.instance.currentUser != null) {
              animationContinue.value = true;
              await Future.delayed(const Duration(milliseconds: 1100));
              Get.offAllNamed(Routes.HOME);
            }
          } on FirebaseAuthException catch (exception) {
            animationContinue.value = true;
            await Future.delayed(const Duration(milliseconds: 1500));
            AuthFailure(exception).checkException();
          }
        }
      }
    } catch (e) {
      animationContinue.value = true;
      await Future.delayed(const Duration(milliseconds: 1500));

      Get.snackbar('Error', e.toString());
    }
  }

  void resetFields() {
    email = '';
    password = '';
    emailValid.value = true;
    emailErrorMessage.value = '';
    passwordValid.value = true;
    passwordErrorMessage.value = '';
  }
}
