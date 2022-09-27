import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/data/errors/auth_failure.dart';
import 'package:qualnote/app/modules/authentication/login/controllers/login_controller.dart';
import 'package:qualnote/app/routes/app_pages.dart';

import '../../../../config/colors.dart';

class RegisterController extends GetxController {
  final loginController = Get.find<LoginController>();
  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  void setUsername(String value) {
    username = value.trim();
    validateUsername();
  }

  void setEmail(String value) {
    email = value.trim();
    validateEmail();
  }

  void setPassword(value) {
    password = value;
    validatePassword();
  }

  void setConfirmPassword(value) {
    confirmPassword = value;
    validateConfirmPassword();
  }

  RxBool usernameValid = true.obs;
  RxString usernameErrorMessage = ''.obs;
  RxBool emailValid = true.obs;
  RxString emailErrorMessage = ''.obs;
  RxBool passwordValid = true.obs;
  RxString passwordErrorMessage = ''.obs;
  RxBool confirmPasswordValid = true.obs;
  RxString confirmPasswordErrorMessage = ''.obs;

  validateUsername() {
    username.isEmpty || username.length < 4
        ? {
            usernameValid.value = false,
            usernameErrorMessage.value = 'Username too short',
          }
        : usernameValid.value = true;
  }

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
        : password.length < 6
            ? {
                passwordValid.value = false,
                passwordErrorMessage.value = 'Password is too short',
              }
            : passwordValid.value = true;
  }

  validateConfirmPassword() {
    confirmPassword.isEmpty
        ? {
            confirmPasswordValid.value = false,
            confirmPasswordErrorMessage.value = 'Please re-enter your password',
          }
        : confirmPassword != password
            ? {
                confirmPasswordValid.value = false,
                confirmPasswordErrorMessage.value = "Passwords don't match",
              }
            : confirmPasswordValid.value = true;
  }

  bool validateFields() {
    validateUsername();
    validateEmail();
    validatePassword();
    validateConfirmPassword();

    return (usernameValid.value == false ||
            emailValid.value == false ||
            passwordValid.value == false ||
            confirmPasswordValid.value == false)
        ? false
        : true;
  }

  Future<void> signUp() async {
    try {
      if (validateFields()) {
        loginController.mainColor = AppColors.darkGreen;
        loginController.animationStart.value = true;
        loginController.animationContinue.value = false;

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
          FirebaseAuth.instance.currentUser!.updateDisplayName(username);
        } on FirebaseAuthException catch (e) {
          loginController.animationContinue.value = true;
          await Future.delayed(const Duration(milliseconds: 1500));
          AuthFailure(e).checkException();
        }
        Get.snackbar(
          'Sign up successful.',
          'Hooray!',
          colorText: AppColors.white,
          backgroundColor: AppColors.darkGreen,
          margin: const EdgeInsets.all(15),
        );
        resetFields();
        loginController.animationContinue.value = true;
        await Future.delayed(const Duration(milliseconds: 1100));
        Get.offAllNamed(Routes.HOME);
      }
    } on FirebaseAuthException catch (e) {
      loginController.animationContinue.value = true;
      await Future.delayed(const Duration(milliseconds: 1500));
      AuthFailure(e).checkException();
    }
  }

  void resetFields() {
    email = '';
    password = '';
    emailValid.value = true;
    emailErrorMessage.value = '';
    passwordValid.value = true;
    passwordErrorMessage.value = '';
    confirmPasswordValid.value = true;
    confirmPasswordErrorMessage.value = '';
  }
}
