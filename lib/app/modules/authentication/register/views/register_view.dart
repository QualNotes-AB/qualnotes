import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/authentication/login/controllers/login_controller.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/auth_button.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/auth_input_field.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/circle_transition.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({Key? key}) : super(key: key);
  final loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Obx(
      () => loginController.animationStart.value
          ? Obx(
              () => LoginTransition(
                paused: loginController.animationContinue.value,
                mainColor: loginController.mainColor,
              ),
            )
          : PageHolder(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(-15, 0),
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: const ButtonStyle(
                        overlayColor: MaterialStatePropertyAll(
                          Color.fromARGB(66, 76, 175, 79),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 40, top: 0),
                    child: Text(
                      'Sign up',
                      style: AppTextStyle.bold32Black,
                    ),
                  ),
                  Obx(
                    () => AuthInputField(
                      hint: 'Enter your username',
                      isValid: controller.usernameValid.value,
                      onChange: (value) => controller.setUsername(value),
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 10),
                      child: Visibility(
                        visible: !controller.usernameValid.value,
                        child: Text(
                          controller.usernameErrorMessage.value,
                          style: AppTextStyle.regular12Red,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => AuthInputField(
                      hint: 'Enter your email',
                      isValid: controller.emailValid.value,
                      onChange: (value) => controller.setEmail(value),
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 10),
                      child: Visibility(
                        visible: !controller.emailValid.value,
                        child: Text(
                          controller.emailErrorMessage.value,
                          style: AppTextStyle.regular12Red,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => AuthInputField(
                      hint: 'Enter your password',
                      obscure: true,
                      isValid: controller.passwordValid.value,
                      onChange: (value) => controller.setPassword(value),
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 10),
                      child: Visibility(
                        visible: !controller.passwordValid.value,
                        child: Text(
                          controller.passwordErrorMessage.value,
                          style: AppTextStyle.regular12Red,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => AuthInputField(
                      hint: 'Confirm your password',
                      obscure: true,
                      isValid: controller.confirmPasswordValid.value,
                      onChange: (value) => controller.setConfirmPassword(value),
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 10),
                      child: Visibility(
                        visible: !controller.confirmPasswordValid.value,
                        child: Text(
                          controller.confirmPasswordErrorMessage.value,
                          style: AppTextStyle.regular12Red,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: AppTextStyle.regular12Black,
                        children: [
                          const TextSpan(
                              text: 'By continuing you agree to the Appka'),
                          TextSpan(
                            text: ' Terms of Service ',
                            style: AppTextStyle.regular12Green,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {}, //TODO Go to terms of service
                          ),
                          const TextSpan(text: 'and'),
                          TextSpan(
                            text: ' Privacy Policy',
                            style: AppTextStyle.regular12Green,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {}, //TODO Go to privacy policy
                          ),
                        ],
                      ),
                    ),
                  ),
                  AuthButton(
                    title: 'Continue',
                    color: AppColors.darkGreen,
                    onPress: () async => await controller.signUp(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: AppTextStyle.semiBold13Black,
                          ),
                          SizedBox(
                            height: 20,
                            child: TextButton(
                                onPressed: () => Get.back(),
                                style: const ButtonStyle(
                                    padding: MaterialStatePropertyAll(
                                        EdgeInsets.zero)),
                                child: const Text(
                                  'Sign in',
                                  style: AppTextStyle.semiBold13Green,
                                )),
                          )
                        ],
                      ),
                      const Text(
                        'or',
                        style: AppTextStyle.semiBold13Black,
                      ),
                    ],
                  ),
                  AuthButton(
                    title: 'Continue with Google',
                    color: AppColors.blue,
                    onPress: () async =>
                        await Get.find<LoginController>().signInWithGoogle(),
                  )
                ],
              ),
            ),
    );
  }
}
