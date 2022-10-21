import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/modules/authentication/login/controllers/login_controller.dart';

class LoginTransition extends StatefulWidget {
  final Color mainColor;
  final Color backgroundColor;
  final bool paused;
  const LoginTransition({
    Key? key,
    this.mainColor = AppColors.darkGreen,
    this.backgroundColor = AppColors.white,
    required this.paused,
  }) : super(key: key);

  @override
  State<LoginTransition> createState() => _LoginTransitionState();
}

class _LoginTransitionState extends State<LoginTransition>
    with TickerProviderStateMixin {
  final controller = Get.find<LoginController>();
  late AnimationController _animation1Controller;
  late Animation<double> animation1;
  late AnimationController _animation2Controller;
  late Animation<double> animation2;
  late AnimationController _animation3Controller;
  late Animation<double> animation3;
  late AnimationController _animation4Controller;
  late Animation<double> animation4;
  late AnimationController _transitionController;
  @override
  void initState() {
    super.initState();
    _animation1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animation1 =
        CurveTween(curve: Curves.easeInOutCubic).animate(_animation1Controller);
    _animation2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    animation2 =
        CurveTween(curve: Curves.fastOutSlowIn).animate(_animation2Controller);
    _animation3Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animation3 =
        CurveTween(curve: ParabolaCurve()).animate(_animation3Controller);
    _animation4Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1150),
    );
    animation4 =
        CurveTween(curve: Curves.easeInOutCubic).animate(_animation4Controller);
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2900),
    );
    if (!controller.animationContinue.value) {
      _transitionController.forward();
      _animation1Controller.forward();
      _animation1Controller.addListener(
        () {
          if (_animation1Controller.value >= 1) {
            _animation2Controller.forward();
          }
        },
      );
      _animation2Controller.addListener(
        () async {
          if (_animation2Controller.value >= 1) {
            if (controller.animationContinue.value) {
              _transitionController.stop();
            }
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _transitionController.dispose();
    _animation1Controller.dispose();
    _animation2Controller.dispose();
    _animation3Controller.dispose();
    _animation4Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.animationContinue.value) {
      _animation1Controller.value = 1;
      _animation2Controller.value = 1;
      _transitionController.forward(from: 0.58);
      _animation4Controller.forward();
      Future.delayed(const Duration(milliseconds: 150));
      _animation3Controller.forward();
      _transitionController.addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            controller.animationStart.value = false;
          }
        },
      );
    }
    return Scaffold(
      body: kIsWeb
          ? Center(
              child: SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  color: widget.mainColor,
                ),
              ),
            )
          : AnimatedBuilder(
              animation: _transitionController,
              builder: (context, child) => CustomPaint(
                painter: TransitionPainter(
                  animation1Progress: animation1.value,
                  animation2Progress: animation2.value,
                  animation3Progress: animation3.value,
                  animation4Progress: animation4.value,
                  backgroundColor: widget.backgroundColor,
                  mainColor: widget.mainColor,
                ),
                child: const Center(
                  child: SizedBox.expand(),
                ),
              ),
            ),
    );
  }
}

class TransitionPainter extends CustomPainter {
  double animation1Progress;
  double animation2Progress;
  double animation3Progress;
  double animation4Progress;
  final Color mainColor;
  final Color backgroundColor;
  TransitionPainter({
    required this.mainColor,
    required this.backgroundColor,
    required this.animation1Progress,
    required this.animation2Progress,
    required this.animation3Progress,
    required this.animation4Progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!kIsWeb) {
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = mainColor;
      var maxRadius =
          size.width > size.height ? size.width + 200 : size.height + 200;

      canvas.drawCircle(
        Offset(size.width / 2, (size.height) / 2),
        maxRadius * animation1Progress,
        paint,
      );

      paint.style = PaintingStyle.stroke;
      paint.color = backgroundColor;
      paint.strokeWidth = 15;
      paint.strokeCap = StrokeCap.round;

      canvas.drawArc(
          Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: 100,
              height: 100),
          0,
          2 * pi * animation2Progress,
          false,
          paint);

      if (animation4Progress > 0.15) {
        paint.style = PaintingStyle.fill;
        paint.color = backgroundColor;
        canvas.drawCircle(
          Offset(size.width / 2, (size.height) / 2),
          maxRadius * animation4Progress,
          paint,
        );
      }
      paint.style = PaintingStyle.fill;
      paint.color = mainColor;

      if (animation3Progress != 1) {
        canvas.drawCircle(
          Offset(size.width / 2, (size.height) / 2),
          140 * animation3Progress,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant TransitionPainter oldDelegate) {
    return (oldDelegate.animation1Progress != animation1Progress ||
        oldDelegate.animation2Progress != animation2Progress ||
        oldDelegate.animation3Progress != animation3Progress);
  }
}

class ParabolaCurve extends Curve {
  @override
  double transformInternal(double t) {
    var value = -3.5 * pow((t - 0.45), 2) + 0.95;
    return value;
  }
}
