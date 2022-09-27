import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/auth_button.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/auth_input_field.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/circle_transition.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';
import 'package:qualnote/app/modules/authentication/register/bindings/register_binding.dart';
import 'package:qualnote/app/modules/authentication/register/views/register_view.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Obx(
      () => controller.animationStart.value
          ? Obx(
              () => LoginTransition(
                paused: controller.animationContinue.value,
                mainColor: controller.mainColor,
              ),
            )
          : PageHolder(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 40, top: 50),
                    child: Text(
                      'Sign in',
                      style: AppTextStyle.bold32Black,
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
                    onPress: () async => await controller.signIn(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: AppTextStyle.semiBold13Black,
                          ),
                          SizedBox(
                            height: 20,
                            child: TextButton(
                              onPressed: () => Get.to(
                                RegisterView(),
                                binding: RegisterBinding(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              ),
                              style: const ButtonStyle(
                                padding: MaterialStatePropertyAll(
                                  EdgeInsets.zero,
                                ),
                              ),
                              child: const Text(
                                'Sign up',
                                style: AppTextStyle.semiBold13Green,
                              ),
                            ),
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
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image.asset(
                        'assets/images/google-icon.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    onPress: () async => await controller.signInWithGoogle(),
                  )
                ],
              ),
            ),
    );
  }
}
