import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qualnote/app/config/colors.dart';
import 'package:qualnote/app/config/text_styles.dart';

class AuthInputField extends StatefulWidget {
  final String hint;
  final bool isValid;
  final bool obscure;
  final Function(String) onChange;

  const AuthInputField({
    Key? key,
    required this.hint,
    required this.isValid,
    required this.onChange,
    this.obscure = false,
  }) : super(key: key);

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField>
    with TickerProviderStateMixin {
  late AnimationController _borderController;
  final FocusNode _focus = FocusNode();
  Color borderColor = AppColors.lightGrey;

  @override
  void initState() {
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _borderController.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    _focus.hasFocus ? _borderController.forward() : _borderController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _borderController,
        builder: (context, child) => CustomPaint(
          painter: BorderPainter(
              animationProgress: _borderController.value,
              isValid: widget.isValid),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _focus,
                      onChanged: widget.onChange,
                      obscureText: widget.obscure,
                      style: AppTextStyle.regular16DarkGrey,
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: AppTextStyle.regular16DarkGrey,
                        contentPadding: const EdgeInsets.all(15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10),
                  //   child: Icon(
                  //     Icons.remove_red_eye_outlined,
                  //     color: AppColors.lightGrey,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  double animationProgress;
  bool isValid;

  BorderPainter({
    required this.animationProgress,
    required this.isValid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const grey = Color(0xFFDADEE3);
    const red = Color.fromARGB(255, 209, 14, 14);
    const green = Color(0xFF05944F);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = isValid ? grey : red;

    paint.strokeCap = StrokeCap.round;

    var midpointLeft = Offset(1, size.height / 2);
    var midpointRight = Offset(size.width - 1, size.height / 2);
    var topLeftArcStart = const Offset(1, 15);
    var topLeftArcEnd = const Offset(16, 0);
    var bottomLeftArcStart = Offset(1, size.height - 15);
    var bottomLeftArcEnd = Offset(16, size.height);
    var topRightArcStartAnim = Offset((size.width - 16) * animationProgress, 0);
    var topRightArcStart = Offset(size.width - 16, 0);
    var topRightArcEnd = Offset(size.width - 1, 15);
    var bottomRightArcStartAnim =
        Offset((size.width - 16) * animationProgress, size.height);
    var bottomRightArcStart = Offset(size.width - 16, size.height);
    var bottomRightArcEnd = Offset(size.width - 1, size.height - 15);

    {
      canvas.drawLine(midpointLeft, topLeftArcStart, paint);
      canvas.drawLine(midpointLeft, bottomLeftArcStart, paint);

      canvas.drawArc(
          Rect.fromCenter(center: const Offset(16, 15), width: 30, height: 30),
          pi,
          pi / 2,
          false,
          paint);
      canvas.drawArc(
        Rect.fromCenter(
            center: Offset(16, size.height - 15), width: 30, height: 30),
        pi / 2,
        pi / 2,
        false,
        paint,
      );

      canvas.drawLine(topLeftArcEnd, topRightArcStart, paint);
      canvas.drawLine(bottomLeftArcEnd, bottomRightArcStart, paint);

      canvas.drawArc(
          Rect.fromCenter(
              center: Offset(size.width - 16, size.height - 15),
              width: 30,
              height: 30),
          0,
          pi / 2,
          false,
          paint);
      canvas.drawArc(
        Rect.fromCenter(
            center: Offset(size.width - 16, 15), width: 30, height: 30),
        -pi / 2,
        pi / 2,
        false,
        paint,
      );

      canvas.drawLine(topRightArcEnd, midpointRight, paint);
      canvas.drawLine(bottomRightArcEnd, midpointRight, paint);
    }

    if (animationProgress > 0) {
      paint.strokeWidth = 2;
      paint.color = isValid ? green : red;
      canvas.drawLine(midpointLeft, topLeftArcStart, paint);
      canvas.drawLine(midpointLeft, bottomLeftArcStart, paint);

      canvas.drawArc(
          Rect.fromCenter(center: const Offset(16, 15), width: 30, height: 30),
          pi,
          pi / 2,
          false,
          paint);
      canvas.drawArc(
        Rect.fromCenter(
            center: Offset(16, size.height - 15), width: 30, height: 30),
        pi / 2,
        pi / 2,
        false,
        paint,
      );

      canvas.drawLine(topLeftArcEnd, topRightArcStartAnim, paint);
      canvas.drawLine(bottomLeftArcEnd, bottomRightArcStartAnim, paint);

      if (animationProgress == 1) {
        canvas.drawArc(
            Rect.fromCenter(
                center: Offset(size.width - 16, size.height - 15),
                width: 30,
                height: 30),
            0,
            pi / 2,
            false,
            paint);
        canvas.drawArc(
          Rect.fromCenter(
              center: Offset(size.width - 16, 15), width: 30, height: 30),
          -pi / 2,
          pi / 2,
          false,
          paint,
        );

        canvas.drawLine(topRightArcEnd, midpointRight, paint);
        canvas.drawLine(bottomRightArcEnd, midpointRight, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BorderPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress;
  }
}
