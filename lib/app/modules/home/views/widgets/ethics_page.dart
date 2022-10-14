import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualnote/app/modules/authentication/login/views/widgets/page_holder.dart';

class EthicsPage extends StatelessWidget {
  const EthicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHolder(
      child: Stack(
        children: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 40,
            ),
          ),
          Center(
            child: Image.asset('assets/ethics.png'),
          ),
        ],
      ),
    );
  }
}
