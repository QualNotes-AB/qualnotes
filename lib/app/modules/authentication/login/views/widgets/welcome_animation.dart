import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';
import 'package:qualnote/app/routes/app_pages.dart';

class WelcomeAnimation extends StatefulWidget {
  final Color mainColor;
  final Color backgroundColor;
  const WelcomeAnimation({
    Key? key,
    this.mainColor = AppColors.darkGreen,
    this.backgroundColor = AppColors.white,
  }) : super(key: key);

  @override
  State<WelcomeAnimation> createState() => _WelcomeAnimationState();
}

class _WelcomeAnimationState extends State<WelcomeAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animation = CurveTween(curve: Curves.easeIn).animate(_animationController);

    _animationController.forward();
    _animationController.addStatusListener(
      (status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(const Duration(seconds: 2));
          _animationController.reverse();
          await Future.delayed(const Duration(seconds: 1));
          Get.offAndToNamed(Routes.LOGIN);
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => CustomPaint(
          painter: TransitionPainter(
            animationProgress: animation.value,
            backgroundColor: widget.backgroundColor,
            mainColor: widget.mainColor,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Text(
                  'Welcome to',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.semiBold20White,
                ),
                SizedBox(height: 5),
                Text(
                  'Qual Notes',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.semiBold24White,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransitionPainter extends CustomPainter {
  double animationProgress;

  final Color mainColor;
  final Color backgroundColor;
  TransitionPainter({
    required this.mainColor,
    required this.backgroundColor,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = mainColor;
    var maxRadius =
        size.width > size.height ? size.width + 200 : size.height + 200;

    if (animationProgress > 0.05) {
      canvas.drawCircle(
        Offset(size.width / 2, (size.height) / 2),
        maxRadius * animationProgress,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TransitionPainter oldDelegate) {
    return (oldDelegate.animationProgress != animationProgress);
  }
}
