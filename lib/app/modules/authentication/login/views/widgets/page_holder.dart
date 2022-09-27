import 'package:flutter/material.dart';

class PageHolder extends StatelessWidget {
  final Widget child;
  const PageHolder({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(child: child),
        ),
      ),
    );
  }
}
