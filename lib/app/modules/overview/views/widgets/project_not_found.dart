import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/routes/app_pages.dart';

class ProjectNotFound extends StatelessWidget {
  const ProjectNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '404',
            style: TextStyle(
              fontSize: 60,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("We can't seem to find the page you're looking for."),
          ),
          FirebaseAuth.instance.currentUser == null
              ? TextButton(
                  onPressed: () => Get.offNamed(Routes.LOGIN),
                  child: const Text('Return to Login'))
              : TextButton(
                  onPressed: () => Get.offNamed(Routes.HOME),
                  child: const Text('Return Home'))
        ],
      )),
    );
  }
}
