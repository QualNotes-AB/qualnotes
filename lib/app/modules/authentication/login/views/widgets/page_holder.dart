import 'package:flutter/material.dart';

class PageHolder extends StatelessWidget {
  final Widget child;
  const PageHolder({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width > 500.0
        ? 500.0
        : MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
