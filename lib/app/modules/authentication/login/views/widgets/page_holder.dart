import 'package:flutter/material.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/internet_status_indicator.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/storage_progress_indicator.dart';

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
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SingleChildScrollView(child: child),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: InternetStatusIndicator()),
                StorageProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
